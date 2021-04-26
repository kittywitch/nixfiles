{ config, lib, pkgs, witch, ... }:

{
  services.transmission = let
    transmission-done-script = pkgs.writeScriptBin "script" ''
      #!${pkgs.bash}/bin/bash
      set -e
      if [ "$TR_TORRENT_DIR"/"$TR_TORRENT_NAME" != "/" ]; then
         cd "$TR_TORRENT_DIR"/"$TR_TORRENT_NAME"
         if [ ! -z "*.rar" ]; then
            ${pkgs.unrar}/bin/unrar x "*.rar"
         fi
         chmod ugo=rwX .
      fi'';
  in {
    enable = true;
    home = "/mnt/zraw/transmission";
    downloadDirPermissions = "777";
    settings = {
      download-dir = "/mnt/zraw/media/unsorted";
      incomplete-dir = "/mnt/zraw/media/.incomplete";
      incomplete-dir-enabled = true;
      rpc-bind-address = "::";
      rpc-whitelist-enabled = false;
      rpc-host-whitelist-enabled = false;
      script-torrent-done-enabled = true;
      dht-enabled = true;
      pex-enabled = true;
      script-torrent-done-filename = "${transmission-done-script}/bin/script";
      umask = 0;
    };
  };

  services.nfs.server.enable = true;
  services.nfs.server.exports =
    "/mnt/zraw/media 192.168.1.0/24(rw) 200::/7(rw) ${witch.secrets.unscoped.ipv6_prefix}(rw)";

  services.jellyfin.enable = true;

  services.nginx.virtualHosts = {
    "samhain.net.kittywit.ch" = {
      useACMEHost = "samhain.net.kittywit.ch";
      forceSSL = true;
      locations = {
        "/jellyfin/".proxyPass = "http://127.0.0.1:8096/jellyfin/";
        "/jellyfin/socket" = {
          proxyPass = "http://127.0.0.1:8096/jellyfin/";
          extraConfig = ''
            proxy_set_header Upgrade $http_upgrade;
            proxy_set_header Connection "upgrade";
          '';
        };
        "/" = {
          root = "/mnt/zraw/media/";
          extraConfig = "autoindex on;";
        };
        "/transmission" = {
          proxyPass = "http://[::1]:9091";
          extraConfig = "proxy_pass_header  X-Transmission-Session-Id;";
        };
      };
    };
    "192.168.1.135" = {
      locations = {
        "/jellyfin/".proxyPass = "http://127.0.0.1:8096/jellyfin/";
        "/jellyfin/socket" = {
          proxyPass = "http://127.0.0.1:8096/jellyfin/";
          extraConfig = ''
            proxy_set_header Upgrade $http_upgrade;
            proxy_set_header Connection "upgrade";
          '';
        };

        "/share/" = {
          alias = "/mnt/zraw/media/";
          extraConfig = "autoindex on;";
        };
      };
    };
    "100.103.111.44" = {
      locations."/share/" = {
        alias = "/mnt/zraw/media/";
        extraConfig = "autoindex on;";
      };
    };
  };
}
