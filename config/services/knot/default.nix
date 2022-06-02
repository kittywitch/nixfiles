{ config, lib, tf, pkgs, ... }:

{
  network.dns.enable = false;

  kw.secrets.variables = {
    katdns-key-config = {
      path = "secrets/katdns";
      field = "notes";
    };
  };

  network.firewall.public = {
    tcp.ports = [ 53 ];
    udp.ports = [ 53 ];
  };

    /* environment.etc."katdns/zones/gensokyo.zone.zone".text = let
    dns = pkgs.dns;
    in dns.lib.toString "gensokyo.zone" (import ./gensokyo.zone.nix { inherit dns lib; }); */

  secrets.files.katdns-keyfile = {
    text = "${tf.variables.katdns-key-config.ref}";
    owner = "knot";
    group = "knot";
  };

  services.knot = {
    enable = true;
    extraConfig = builtins.readFile ./knot.yaml;
    keyFiles = [
      config.secrets.files.katdns-keyfile.path
    ];
  };
}
