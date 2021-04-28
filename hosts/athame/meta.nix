{ config, hosts, lib, ... }:
with config.resources; {
  resources.hcloud_ssh_key = {
    provider = "hcloud";
    type = "ssh_key";
    inputs = {
      name = "yubikey";
      public_key =
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCocjQqiDIvzq+Qu3jkf7FXw5piwtvZ1Mihw9cVjdVcsra3U2c9WYtYrA3rS50N3p00oUqQm9z1KUrvHzdE+03ZCrvaGdrtYVsaeoCuuvw7qxTQRbItTAEsfRcZLQ5c1v/57HNYNEsjVrt8VukMPRXWgl+lmzh37dd9w45cCY1QPi+JXQQ/4i9Vc3aWSe4X6PHOEMSBHxepnxm5VNHm4PObGcVbjBf0OkunMeztd1YYA9sEPyEK3b8IHxDl34e5t6NDLCIDz0N/UgzCxSxoz+YJ0feQuZtud/YLkuQcMxW2dSGvnJ0nYy7SA5DkW1oqcy6CGDndHl5StOlJ1IF9aGh0gGkx5SRrV7HOGvapR60RphKrR5zQbFFka99kvSQgOZqSB3CGDEQGHv8dXKXIFlzX78jjWDOBT67vA/M9BK9FS2iNnBF5x6shJ9SU5IK4ySxq8qvN7Us8emkN3pyO8yqgsSOzzJT1JmWUAx0tZWG/BwKcFBHfceAPQl6pwxx28TM3BTBRYdzPJLTkAy48y6iXW6UYdfAPlShy79IYjQtEThTuIiEzdzgYdros0x3PDniuAP0KOKMgbikr0gRa6zahPjf0qqBnHeLB6nHAfaVzI0aNbhOg2bdOueE1FX0x48sjKqjOpjlIfq4WeZp9REr2YHEsoLFOBfgId5P3BPtpBQ== cardno:000612078454";
    };
  };

  resources.athame = {
    provider = "null";
    type = "resource";
    connection = {
      port = 62954;
      host = "athame.kittywit.ch";
    };
  };

  #resources.athame = {
  #provider = "hcloud";
  #  type = "server";
  #  inputs = {
  #    name = "athame";
  #    image = "ubuntu-20.04";
  #    server_type = "cpx21";
  #    location = "nbg1";
  #    backups = false;
  #    ssh_keys = [ (hcloud_ssh_key.refAttr "id") ];
  #  };
  #  connection = { host = config.lib.tf.terraformSelf "ipv4_address"; };
  #  provisioners = [
  #    {
  #      file = {
  #        destination = "/tmp/sshportfix.nix";
  #        content = "{ config, ...}: { services.openssh.ports = [ 62954 ]; }";
  #      };
  #    }
  #    {
  #      remote-exec.command =
  #        "curl https://raw.githubusercontent.com/elitak/nixos-infect/master/nixos-infect | NIXOS_IMPORT=/tmp/sshportfix.nix NO_REBOOT=true PROVIDER=hetznercloud NIX_CHANNEL=nixos-20.09 bash 2>&1 | tee /tmp/infect.log";
  #    }
  #    {
  #      remote-exec.command = "reboot";
  #      onFailure = "continue";
  #    }
  #  ];
  #};

  /* resources.athame_rdns = {
       provider = "hcloud";
       type = "rdns";
       inputs = {
         server_id = athame.refAttr "id";
         dns_ptr = "athame.kittywit.ch";
         ip_address = athame.refAttr "ipv4_address";
       };
     };
  */

  #dns.records.kittywitch_athame = {
  #  tld = "kittywit.ch.";
  #  domain = "athame";
  #  a.address = athame.refAttr "ipv4_address";
  #};

  #dns.records.kittywitch_root = {
  #  tld = "kittywit.ch.";
  #  domain = "@";
  #  a.address = athame.refAttr "ipv4_address";
  #};

  #dns.records.kittywitch_athame_v6 = {
  #  tld = "kittywit.ch.";
  #  domain = "athame";
  #  aaaa.address = athame.refAttr "ipv6_address";
  #};

  #dns.records.kittywitch_root_v6 = {
  #  tld = "kittywit.ch.";
  #  domain = "@";
  #  aaaa.address = athame.refAttr "ipv6_address";
  #};

  #dns.records.kittywitch_www = {
  #  tld = "kittywit.ch.";
  #  domain = "www";
  #  cname.target = "athame.kittywit.ch.";
  #};

  #    connection = {
  #      host = athame.refAttr "ipv4_address";
  #      port = 62954;
  #    };

  #triggers.switch = lib.mapAttrs (name: record:
  #  {
  #    A = config.lib.tf.terraformExpr
  #      ''join(",", ${record.out.resource.namedRef}.addresses)'';
  #    AAAA = config.lib.tf.terraformExpr
  #      ''join(",", ${record.out.resource.namedRef}.addresses)'';
  #    CNAME = record.out.resource.refAttr "cname";
  #    SRV = record.out.resource.refAttr "id";
  #  }.${record.out.type}) config.dns.records;

}
