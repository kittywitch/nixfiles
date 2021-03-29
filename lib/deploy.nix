{ pkgs, hosts, sources, groups }:

with pkgs.lib;

let
  pkgsModule = { ... }: { config._module.args = { pkgs = mkDefault pkgs; }; };

  tfEval = config:
    (evalModules {
      modules = [ pkgsModule (sources.tf-nix + "/modules") ] ++ toList config;
      specialArgs = { };
    }).config;

  tf = makeOverridable ({ group ? null, host ? null }: tfEval ({ config, ... }: {
    deps = { 
      enable = true;
      select.hclPaths = (map (name: config.resources."${name}_system_switch".out.hclPathStr) (if host != null then [ host ] else (if group != null then groups.${group} else []) ));
    };

    state = { file = toString ../private/files/tf/terraform.tfstate; };

    runners.lazy = {
      file = ../.;
      args = [ "--show-trace" ];
      attrPrefix = let attr = if host != null then "host.${host}" else if group != null then "group.${group}" else "tf"; in "deploy.${attr}.runners.run.";
    };

    terraform = {
      dataDir = toString ../private/files/tf/tfdata;
      logPath = toString ../private/files/tf/terraform.log;
    };

    variables.hcloud_token = {
      type = "string";
      value.shellCommand = "bitw get infra/hcloud_token";
    };

    providers.hcloud = { inputs.token = config.variables.hcloud_token.ref; };

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

      athame = { provider = "null"; type = "resource"; connection = { port = 62954; host = "athame.kittywit.ch"; }; };
      samhain = { provider = "null"; type = "resource"; connection = { port = 62954; host = "192.168.1.135"; }; };
      yule = { provider = "null"; type = "resource"; connection = { port = 62954; host = "192.168.1.92"; }; };

      athame-testing = {
        provider = "hcloud";
        type = "server";
        inputs = {
          name = "athame-testing";
          image = "ubuntu-20.04";
          server_type = "cpx21";
          location = "nbg1";
          backups = false;
          ssh_keys = [ (hcloud_ssh_key.refAttr "id") ];
        };
        connection = { host = config.lib.tf.terraformSelf "ipv4_address"; };
        provisioners = [
          {
            remote-exec.command =
              "curl https://raw.githubusercontent.com/elitak/nixos-infect/master/nixos-infect | NO_REBOOT=true PROVIDER=hetznercloud NIX_CHANNEL=nixos-20.09 bash 2>&1 | tee /tmp/infect.log";
          }
          {
            remote-exec.command = "reboot";
            onFailure = "continue";
          }
        ];
      };
    };

    deploy.systems.athame = with config.resources; {
      nixosConfig = hosts.athame.config;
      connection = athame.connection.set;
      triggers.copy.athame = athame.refAttr "id";
      triggers.secrets.athame = athame.refAttr "id";
    };
    deploy.systems.samhain = with config.resources; {
      nixosConfig = hosts.samhain.config;
      connection = samhain.connection.set;
      triggers.copy.samhain = athame.refAttr "id";
      triggers.secrets.samhain = athame.refAttr "id";
    };
    deploy.systems.yule = with config.resources; {
      nixosConfig = hosts.yule.config;
      connection = yule.connection.set;
      triggers.copy.yule = athame.refAttr "id";
      triggers.secrets.yule = athame.refAttr "id";
    };
  })) {};
in { 
  inherit tf; 
  group = genAttrs (attrNames groups) (group: (tf.override { inherit group; })); 
  host = genAttrs (attrNames hosts) (host:  (tf.override { inherit host; }));  
}
