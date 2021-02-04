{ config, pkgs, ... }:

{
  users.users.kat = {
    uid = 1000;
    isNormalUser = true;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDX2x9eT02eJn2lAc7zA3c84+FXkft1f3hbTXKZ6+q/F kat@yule"
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCno0Ci2VEkxgWu1mR24puvphHw3KdaNelEhS7n5LEtNuFuNLd0vhQkP5sWGqg4W9pjcHELV8898Bz7+K+ikbZgD2yiK9ROFxSZc/e47H5m9Yn74blrahFmu4S1RL+UPlqnJoUwULsP28xDW3iZbBYnWffMGWXL6Yr8oAdMvOMmKf6KZ/akfRIB22kS6y1XeJnfnzQZRImr+whrNiXKrCXqlcINLkObZW0Wv+BwfXKMhD0lqlTJYAyMdmfWy7ARep032A/XE+gOcln9Ut55GcVwS45LreZuXlk66lHZvFNeK0ETa079Fl7Bx4kYhuek48bIYwpqsIPW+1CDNyeW79Fd dorkd@DESKTOP-U9VEBIL"
    ];
    shell = pkgs.fish;
    extraGroups = [ "wheel" ];
  };

  home-manager.useGlobalPkgs = true;
  home-manager.users.kat = {
    programs.fish = {
      enable = true;
      plugins = [{
        name = "bass";
        src = pkgs.fetchFromGitHub {
          owner = "edc";
          repo = "bass";
          rev = "d63054b24c2f63aaa3a08fb9ec9d0da4c70ab922";
          sha256 = "0pwci5xxm8308nrb52s5nyxijk0svar8nqrdfvkk2y34z1cg319b";
        };
      }];
    };

    programs.starship = {
      enable = true;
      enableFishIntegration = true;
    };

    programs.git = {
      enable = true;
      userName = "katrin fénix";
      userEmail = "me@dork.dev";
    };

    programs.kakoune = { enable = true; };

    programs.ssh = {
      enable = true;
      controlMaster = "auto";
      controlPersist = "10m";
      hashKnownHosts = true;
      matchBlocks = let
        kat = {
          forwardAgent = true;
          extraOptions = {
            RemoteForward =
              "/run/user/1000/gnupg/S.gpg-agent /run/user/1000/gnupg/S.gpg-agent.extra";
          };
          port = 62954;
        };
      in {
        "beltane" = { hostname = "beltane.dork.dev"; } // kat;
        "samhain" = { hostname = "192.168.1.135"; } // kat;
        "litha" = { hostname = "192.168.1.240"; } // kat;
        "yule" = { hostname = "192.168.1.92"; } // kat;
        "mabon" = { hostname = "192.168.1.218"; } // kat;
        "boline" = { hostname = "boline.kittywit.ch"; } // kat;
      };
    };

    programs.bat.enable = true;
    programs.tmux.enable = true;
  };
}
