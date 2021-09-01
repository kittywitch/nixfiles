{ config, lib, tf, pkgs, ... }:

{
  kw.secrets.variables = {
    katdns-key = {
      path = "secrets/katdns";
      field = "notes";
    };
  };

  network.firewall.public = {
    tcp.ports = [ 53 ];
    udp.ports = [ 53 ];
  };

  secrets.files.katdns-keyfile = {
    text = "${tf.variables.katdns-key.ref}";
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
