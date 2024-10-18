{config, ...}: let
  fqdn = "${config.networking.hostName}.inskip.me";
in {
  services.nginx = {
    virtualHosts = {
      "${fqdn}" = {
        enableACME = true;
        forceSSL = true;
        locations = {
          "/".extraConfig = ''
            return 404;
          '';
          "/_matrix".proxyPass = "http://[::1]:8008";
          "/_synapse".proxyPass = "http://[::1]:8008";
        };
        extraConfig = ''
          http2_max_requests 100000;
          keepalive_requests 100000;
        '';
      };
    };
  };
}
