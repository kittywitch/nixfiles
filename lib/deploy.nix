{ pkgs, hosts, sources, targets }:

with pkgs.lib;

let
  pkgsModule = { ... }: { config._module.args = { pkgs = mkDefault pkgs; }; };

  tfEval = config:
    (evalModules {
      modules = [ pkgsModule (sources.tf-nix + "/modules") ] ++ toList config;
      specialArgs = { inherit hosts; };
    }).config;

  tf = { targetName, target }:
    tfEval ({ config, ... }: {
      imports = map (hostName: ../hosts + "/${hostName}/meta.nix") target ++ [{
        config = mkMerge (map (hostName:
          mapAttrs (_: mkMerge) hosts.${hostName}.config.deploy.tf.out.set)
          target);
      }] ++ concatMap (hostName:
        filter builtins.pathExists
        (map (profile: ../profiles + "/${profile}/meta.nix") (attrNames
          (filterAttrs (_: id) hosts.${hostName}.config.deploy.profile))))
        target;

      deps = {
        select.allProviders = true;
        enable = true;
      };

      state = {
        file = ../private/files/tf + "/terraform-${targetName}.tfstate";
      };

      runners.lazy = {
        file = ../.;
        args = [ "--show-trace" ];
        attrPrefix =
          let attr = if target != null then "target.${targetName}" else "tf";
          in "deploy.${attr}.runners.run.";
      };

      terraform = {
        dataDir = ../private/files/tf + "/tfdata/${targetName}";
        logPath = ../private/files/tf + "/terraform-${targetName}.log";
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
   });
in {
  inherit tf;
  target =
    mapAttrs (targetName: target: tf { inherit target targetName; }) targets;
}
