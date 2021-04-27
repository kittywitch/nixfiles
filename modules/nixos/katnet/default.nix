{ config, hosts, lib, pkgs, ... }:

with lib;

{
  config = mkIf config.hexchen.network.enable {
    deploy.tf.dns.records."kittywitch_net_${config.networking.hostName}" = {
      tld = "kittywit.ch.";
      domain = "${config.networking.hostName}.net";
      aaaa.address = config.hexchen.network.address;
    };
  };
}
