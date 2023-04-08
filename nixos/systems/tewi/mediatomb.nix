{ config, lib, ... }: with lib; let
  cfg = config.services.mediatomb;
  shadowDir = "/mnt/shadow";
  inherit (config.services) deluge;
  delugeDir = "${shadowDir}/deluge";
in {
  services.mediatomb = {
    enable = true;
    openFirewall = true;
    serverName = config.networking.hostName;
    uuid = "082fd344-bf69-5b72-a68f-a5a4d88e76b2";
    mediaDirectories = [
      {
        path = "${shadowDir}/media";
        recursive = true;
        hidden-files = false;
      }
      (mkIf deluge.enable {
        path = delugeDir;
        recursive = true;
        hidden-files = false;
      })
    ];
  };
  systemd.services.mediatomb = {
    confinement.enable = true;
    unitConfig = {
      RequiresMountsFor = [
        shadowDir
      ];
    };
    serviceConfig = {
      StateDirectory = cfg.package.pname;
      BindReadOnlyPaths = mkMerge [
        (map (path: "${shadowDir}/media/${path}") [
          "anime" "movies" "tv" "unsorted"
          "music" "music-to-import" "music-raw"
        ])
        (mkIf deluge.enable [ "${delugeDir}/complete" ])
      ];
    };
  };
}
