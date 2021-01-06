{ config, lib, pkgs, ... }:

{

  environment.systemPackages = let
    python-env = python-packages:
      with pkgs.python38Packages; [
        pip
        setuptools
        psutil
      ];
    python-with-env = pkgs.python3.withPackages python-env;
  in [ pkgs.php pkgs.php74Packages.composer2 python-with-env ];

  home-manager.users.kat = {
    programs.go.enable = true;

    programs.fish = {
      interactiveShellInit = ''
        set fish_user_paths $fish_user_paths $HOME/.config/composer/vendor/bin
      '';
    };

    home.packages = [
      pkgs.jetbrains.clion
      pkgs.jetbrains.idea-ultimate
      pkgs.jetbrains.goland
      pkgs.jetbrains.phpstorm
      pkgs.nixfmt
      pkgs.carnix
      pkgs.rustup
      pkgs.gcc
    ];
  };
}
