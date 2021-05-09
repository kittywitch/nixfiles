{ config, pkgs, ... }:

{
  services.transmission =
    let
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
    in
    {
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
}
