{ config, lib, ... }: let
  cfg = config.services.mediatomb;
  shadowDir = "/mnt/shadow";
in {
  services.mediatomb = {
    enable = true;
    openFirewall = true;
    serverName = config.networking.hostName;
    uuid = "082fd344-bf69-5b72-a68f-a5a4d88e76b2";
    mediaDirectories = lib.singleton {
      path = "${shadowDir}/media";
      recursive = true;
      hidden-files = false;
    };
  };
  systemd.services.mediatomb = rec {
    confinement.enable = true;
    unitConfig = {
      RequiresMountsFor = [
        shadowDir
      ];
    };
    serviceConfig = {
      StateDirectory = cfg.package.pname;
      BindReadOnlyPaths = map (path: "${shadowDir}/media/${path}") [
        "anime" "movies" "tv" "unsorted"
        "music" "music-to-import" "music-raw"
      ] ++ [
        "${shadowDir}/deluge/complete"
      ];
    };
  };
}
