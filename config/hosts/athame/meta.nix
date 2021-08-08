{ lib, config, profiles, ... }: with lib; {
config = {
    deploy.targets.infra = {
      tf = {
        resources.athame = {
          provider = "null";
          type = "resource";
          connection = {
            port = 62954;
            host = "athame.kittywit.ch";
          };
        };
      };
    };
    network.nodes.athame = {
      imports = lib.hostImport {
        hostName = "athame";
        inherit profiles;
      };
      networking = {
        hostName = "athame";
      };
    };
  };
}

# For the eventual migration

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

