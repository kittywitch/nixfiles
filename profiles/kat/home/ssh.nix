{ config, pkgs, lib, ... }:

{
    programs.ssh = {
      enable = true;
      controlMaster = "auto";
      controlPersist = "10m";
      hashKnownHosts = true;
      matchBlocks = let
        common = {
          forwardAgent = true;
          extraOptions = {
            RemoteForward =
              "/run/user/1000/gnupg/S.gpg-agent /run/user/1000/gnupg/S.gpg-agent.extra";
          };
          port = 62954;
        };
      in {
        "athame" = { hostname = "athame.kittywit.ch"; } // common;
        "samhain" = { hostname = "192.168.1.135"; } // common;
        "yule" = { hostname = "192.168.1.92"; } // common;
        "boline" = { hostname = "boline.kittywit.ch"; } // common;
      };
    };
}
