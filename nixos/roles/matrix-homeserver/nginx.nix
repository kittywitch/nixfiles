{config, ...}: let
  fqdn = "${config.networking.hostName}.${config.networking.domain}";
  clientConfig = {
    "m.homeserver".base_url = "https://${fqdn}";
    "m.identity_server".base_url = "https://vector.im";
  };
  serverConfig."m.server" = "${fqdn}:443";
  mkWellKnown = data: ''
    add_header Content-Type application/json;
    add_header Access-Control-Allow-Origin *;
    return 200 '${builtins.toJSON data}';
  '';
in {
  services.nginx = {
    virtualHosts = {
      "kittywit.ch" = {
        enableACME = true;
        forceSSL = true;
        acmeRoot = null;
        locations."= /.well-known/matrix/server".extraConfig = mkWellKnown serverConfig;
        locations."= /.well-known/matrix/client".extraConfig = mkWellKnown clientConfig;
      };
      "${fqdn}" = {
        enableACME = true;
        forceSSL = true;
        locations."/".extraConfig = ''
          return 404;
        '';
        locations."/_matrix".proxyPass = "http://[::1]:8008";
        locations."/_synapse/client".proxyPass = "http://[::1]:8008";
        extraConfig = ''
          http2_max_requests 100000;
          keepalive_requests 100000;
        '';
      };
    };
  };
}