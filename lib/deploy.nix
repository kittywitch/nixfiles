{ pkgs, hosts, sources, groups }:

with pkgs.lib;

let
  pkgsModule = { ... }: { config._module.args = { pkgs = mkDefault pkgs; }; };

  tfEval = config:
    (evalModules {
      modules = [ pkgsModule (sources.tf-nix + "/modules") ] ++ toList config;
      specialArgs = { inherit hosts; };
    }).config;

  tf = makeOverridable ({ group ? null, host ? null }:
    tfEval ({ config, ... }: {
      imports =
        mapAttrsToList (name: host: import (../hosts + "/${name}/meta.nix"))
        hosts ++ [{ config = mkMerge (mapAttrsToList (_: host: mapAttrs (_: mkMerge) host.config.deploy.tf.out.set) hosts); }];

        deps = {
        select.allProviders = true;
        enable = true;
        select.hclPaths =
          (map (name: config.resources."${name}_system_switch".out.hclPathStr)
            (if host != null then
              [ host ]
            else
              (if group != null then groups.${group} else [ ])));
      };

      state = { file = toString ../private/files/tf/terraform.tfstate; };

      runners.lazy = {
        file = ../.;
        args = [ "--show-trace" ];
        attrPrefix = let
          attr = if host != null then
            "host.${host}"
          else if group != null then
            "group.${group}"
          else
            "tf";
        in "deploy.${attr}.runners.run.";
      };

      terraform = {
        dataDir = toString ../private/files/tf/tfdata;
        logPath = toString ../private/files/tf/terraform.log;
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

      resources = with config.resources; {
        hcloud_ssh_key = {
          provider = "hcloud";
          type = "ssh_key";
          inputs = {
            name = "yubikey";
            public_key =
              "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCocjQqiDIvzq+Qu3jkf7FXw5piwtvZ1Mihw9cVjdVcsra3U2c9WYtYrA3rS50N3p00oUqQm9z1KUrvHzdE+03ZCrvaGdrtYVsaeoCuuvw7qxTQRbItTAEsfRcZLQ5c1v/57HNYNEsjVrt8VukMPRXWgl+lmzh37dd9w45cCY1QPi+JXQQ/4i9Vc3aWSe4X6PHOEMSBHxepnxm5VNHm4PObGcVbjBf0OkunMeztd1YYA9sEPyEK3b8IHxDl34e5t6NDLCIDz0N/UgzCxSxoz+YJ0feQuZtud/YLkuQcMxW2dSGvnJ0nYy7SA5DkW1oqcy6CGDndHl5StOlJ1IF9aGh0gGkx5SRrV7HOGvapR60RphKrR5zQbFFka99kvSQgOZqSB3CGDEQGHv8dXKXIFlzX78jjWDOBT67vA/M9BK9FS2iNnBF5x6shJ9SU5IK4ySxq8qvN7Us8emkN3pyO8yqgsSOzzJT1JmWUAx0tZWG/BwKcFBHfceAPQl6pwxx28TM3BTBRYdzPJLTkAy48y6iXW6UYdfAPlShy79IYjQtEThTuIiEzdzgYdros0x3PDniuAP0KOKMgbikr0gRa6zahPjf0qqBnHeLB6nHAfaVzI0aNbhOg2bdOueE1FX0x48sjKqjOpjlIfq4WeZp9REr2YHEsoLFOBfgId5P3BPtpBQ== cardno:000612078454";
          };
        };
      };
    })) { };
in {
  inherit tf;
  group = genAttrs (attrNames groups) (group: (tf.override { inherit group; }));
  host = genAttrs (attrNames hosts) (host: (tf.override { inherit host; }));
}
