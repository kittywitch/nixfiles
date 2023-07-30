{config, ...}: let
  fqdn = "${config.networking.hostName}.${config.networking.domain}";
in {
  services.nginx = {
    virtualHosts = {
      "${fqdn}" = {
        enableACME = true;
        forceSSL = true;
        locations."/".extraConfig = ''
          return 404;
        '';
        locations."/_matrix".proxyPass = "http://[::1]:8008";
        locations."/_synapse".proxyPass = "http://[::1]:8008";
        extraConfig = ''
          http2_max_requests 100000;
          keepalive_requests 100000;
        '';
      };
    };
  };
}
