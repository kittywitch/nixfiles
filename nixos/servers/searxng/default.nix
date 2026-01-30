{ config, lib, ... }: let
  domain = "search.kittywit.ch";
  cfg = config.services.searx;
in {
  sops.secrets.searx-env = {
    sopsFile = ./secrets.yaml;
  };
  systemd.services.nginx.serviceConfig.SupplementaryGroups = [ "searx " ];
  services = {
    searx = {
      enable = true;
      configureUwsgi = true;
      redisCreateLocally = true;
      settings = {
        server.secret_key = "$SEARXNG_SECRET";
      };
      environmentFile = config.sops.secrets.searx-env.path;
    };
    uwsgi.instance.vassals.searx = {
      socket = "/run/searx/uwsgi.sock";
      chmod-socket = "660";
    };
    nginx.virtualHosts.${domain} = {
      listen = let
        addrs = ["100.73.129.88" "[fd7a:115c:a1e0::5634:8158]"];
      in map (addr:
          {
            port = 443;
            ssl = true;
            inherit addr;
          }) addrs;
      enableACME = true;
      forceSSL = true;
      acmeRoot = null;
      locations = {
        "/" = {
          recommendedProxySettings = true;
          recommendedUwsgiSettings = true;
          uwsgiPass = "unix:${config.services.uwsgi.instance.vassals.searx.socket}";
          extraConfig = # nginx
            ''
                uwsgi_param  HTTP_HOST             $host;
                uwsgi_param  HTTP_CONNECTION       $http_connection;
                uwsgi_param  HTTP_X_SCHEME         $scheme;
                uwsgi_param  HTTP_X_SCRIPT_NAME    ""; # NOTE: When we ever make the path configurable, this must be set to anything not "/"!
                uwsgi_param  HTTP_X_REAL_IP        $remote_addr;
                uwsgi_param  HTTP_X_FORWARDED_FOR  $proxy_add_x_forwarded_for;
            '';
        };
        "/static/".alias = lib.mkDefault "${cfg.package}/share/static/";
      };
    };
  };
}
