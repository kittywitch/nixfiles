{ pkgs, hosts, sources, targets }:

with pkgs.lib;

let
  pkgsModule = { ... }: { config._module.args = { pkgs = mkDefault pkgs; }; };

  configExtension = { ... }: {
    options.terraform.baseDir = mkOption {
      type = types.path;
    };
  };

  tfEval = config:
    (evalModules {
      modules = [ pkgsModule (sources.tf-nix + "/modules") configExtension ] ++ toList config;
      specialArgs = { inherit hosts; };
    }).config;

  tf = { targetName ? null, target ? [] }:
    tfEval ({ config, ... }: {
      imports = optional (builtins.pathExists ../trusted/tf) (import ../trusted/tf/meta.nix)
        ++ flatten (map (hostName: optional (builtins.pathExists (../hosts + "/${hostName}/meta.nix")) (../hosts + "/${hostName}/meta.nix")) target) ++ [{
        config = mkMerge (map
          (hostName:
            mapAttrs (_: mkMerge) hosts.${hostName}.config.deploy.tf.out.set)
          target);
      }] ++ optional
        (targetName != null && builtins.pathExists (../trusted/targets + "/${targetName}"))
        (../trusted/targets + "/${targetName}")
        ++ optional (targetName != null && builtins.pathExists (../targets + "/${targetName}"))
        (../targets + "/${targetName}") ++ concatMap
        (hostName:
          filter builtins.pathExists
            (map (profile: ../profiles + "/${profile}/meta.nix") (attrNames
              (filterAttrs (_: id) hosts.${hostName}.config.deploy.profile))))
        target;

      deps = {
        select.allProviders = true;
        enable = true;
      };

      terraform.version = "0.15";

      runners = {
        lazy = {
          file = ../.;
          args = [ "--show-trace" ];
          attrPrefix =
            let attr = if targetName != null then "target.${targetName}" else "tf";
            in "deploy.${attr}.runners.run.";
          };
          run = {
            apply.name = if targetName != null then "${targetName}-apply" else "tf-apply";
          };
      };

      variables.hcloud_token = {
        type = "string";
        value.shellCommand = "bitw get infra/hcloud_token";
      };

      variables.glauca_key = {
        type = "string";
        value.shellCommand = "bitw get infra/rfc2136 -f username";
      };

      variables.glauca_secret = {
        type = "string";
        value.shellCommand = "bitw get infra/rfc2136 -f password";
      };

      dns.zones."kittywit.ch." = { provider = "dns"; };

      providers.hcloud = { inputs.token = config.variables.hcloud_token.ref; };

      providers.dns = {
        inputs.update = {
          server = "ns1.as207960.net";
          key_name = config.variables.glauca_key.ref;
          key_secret = config.variables.glauca_secret.ref;
          key_algorithm = "hmac-sha512";
        };
      };

      _module.args = {
        inherit targetName;
      };
    });
in
{
  inherit tf;
  target =
    mapAttrs (targetName: target: tf { inherit target targetName; }) targets;
}
