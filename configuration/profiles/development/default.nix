{ config, lib, pkgs, ... }: {
  environment.systemPackages = [ pkgs.php pkgs.php74Packages.composer2 ];

  home-manager.users.kat = {
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
