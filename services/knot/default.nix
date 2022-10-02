{ config, lib, tf, pkgs, ... }:

{
  secrets.variables = {
    katdns-key-config = {
      path = "secrets/katdns";
      field = "notes";
    };
  };

  networks.internet = {
    tcp = [ 53 ];
    udp = [ 53 ];
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
