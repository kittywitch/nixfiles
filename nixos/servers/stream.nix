_: {
  networking.firewall.allowedTCPPorts = [
    1935
  ];
  systemd.services.nginx.serviceConfig.BindPaths = [
    "/var/www/streamy"
  ];
  services.nginx = let
    streamyHome = "/var/www/streamy";
  in {
    virtualHosts."stream.kittywit.ch" = {
      enableACME = true;
      forceSSL = true;
      acmeRoot = null;
      locations = {
        "/" = {
          root = streamyHome;
        };
      };
    };
    appendConfig = ''
      rtmp {
        server {
          listen 1935;
          chunk_size 4096;
          application animu {
            allow publish 100.64.0.0/10;
            deny publish all;

            live on;
            record off;
            hls on;
            hls_path ${streamyHome}/hls;
            hls_fragment 1;
            hls_playlist_length 20;

            dash on;
            dash_path ${streamyHome}/dash;
          }
        }
      }
    '';
  };
}
