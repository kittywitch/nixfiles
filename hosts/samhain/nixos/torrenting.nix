{ config, lib, pkgs, ... }:

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

  services.samba = {
    enable = true;
    securityType = "user";
    extraConfig = ''
      workgroup = WORKGROUP
      server string = samhain
      netbios name = samhain
      security = user 
      #use sendfile = yes
      #max protocol = smb2
      hosts allow = 192.168.1. 192.168.122. localhost
      hosts deny = 0.0.0.0/0
      guest account = nobody
      map to guest = bad user
    '';
    shares = {
      shared = {
        path = "/home/kat/shared";
        browseable = "yes";
        "read only" = "no";
        "guest ok" = "no";
        "create mask" = "0644";
        "directory mask" = "0755";
        "force user" = "kat";
        "force group" = "users";
      };
      media = {
        path = "/mnt/zraw/media";
        browseable = "yes";
        "read only" = "no";
        "guest ok" = "yes";
        "create mask" = "0644";
        "directory mask" = "0755";
        "force user" = "transmission";
        "force group" = "transmission";
      };
    };
  };

  services.nginx.virtualHosts = {
    "192.168.1.135" = {
      locations."/share/" = {
        alias = "/mnt/zraw/media/";
        extraConfig = "autoindex on;";
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
