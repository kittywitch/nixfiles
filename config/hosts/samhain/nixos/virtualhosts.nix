{ config, lib, ... }:

with lib;

{
  kw.fw.private.tcp.ports = singleton 1935;
  kw.fw.public.tcp.ports = singleton 1935;

  services.nginx.appendConfig = ''
    rtmp {
      server {
        listen [::]:1935 ipv6only=off;
        application kattv {
          live on;

          allow publish all;
          allow play all;
        }
      }
    }
  '';
}
