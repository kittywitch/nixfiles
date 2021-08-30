{ config, lib, tf, pkgs, ... }:

{
  kw.secrets = [ "knot-dnsupdate" ];

  network.firewall.public = {
    tcp.ports = [ 53 ];
    udp.ports = [ 53 ];
  };

  secrets.files.knot-dnsupdate = {
    text = "${tf.variables.knot-dnsupdate.ref}";
    owner = "knot";
    group = "knot";
  };

/*  environment.etc."katdns/zones/kittywit.ch.zone".text = let
    dns = pkgs.dns;
    in dns.lib.toString "kittywit.ch" (import ./kittywit.ch.nix { inherit dns lib; }); */

  services.knot = {
    enable = true;
    extraConfig = builtins.readFile ./knot.yaml;
    keyFiles = [
      config.secrets.files.knot-dnsupdate.path
    ];
  };
}
