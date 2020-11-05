{ config, pkgs, ... }:

{
  users.users.root = {
    openssh.authorizedKeys.keys = with pkgs.lib; concatLists (mapAttrsToList (name: user: if elem "wheel" user.extraGroups then user.openssh.authorizedKeys.keys else []) config.users.users);
  };

  users.users.kat = {
    uid = 1000;
    isNormalUser = true;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDX2x9eT02eJn2lAc7zA3c84+FXkft1f3hbTXKZ6+q/F kat@yule"
    ];
    shell = pkgs.fish;
    extraGroups = [ "wheel" ];
  };

  home-manager.useGlobalPkgs = true;
  home-manager.users.kat = {
    programs.firefox = {
      enable = true;
    };

    programs.fish = {
      enable = true;
      plugins = [
        {
          name = "bass";
          src = pkgs.fetchFromGitHub {
            owner = "edc";
            repo = "bass";
            rev = "d63054b24c2f63aaa3a08fb9ec9d0da4c70ab922";
            sha256 = "0pwci5xxm8308nrb52s5nyxijk0svar8nqrdfvkk2y34z1cg319b";
          };
        }
      ];
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

    programs.kakoune = {
      enable = true;
    };

    programs.ssh = {
      enable = true;
      controlMaster = "auto";
      controlPersist = "10m";
      hashKnownHosts = true;
      matchBlocks = let
        kat = {
          forwardAgent = true;
          extraOptions = {
            RemoteForward = "/run/user/1000/gnupg/S.gpg-agent /run/user/1000/gnupg/S.gpg-agent.extra";
          };
          port = 62954;
        };
      in {
        "beltane" = {
          hostname = "beltane.dork.dev";
        } // kat;
        "samhain" = {
          hostname = "192.168.1.135";
        } // kat;
        "litha" = {
          hostname = "192.168.1.240";
        } // kat;
        "yule" = {
          hostname = "192.168.1.92";
        } // kat;
      };
    };

    programs.bat.enable = true;
    programs.tmux.enable = true;
  };
}