{ config, lib, pkgs, sources, ... }:

{
  boot.loader.grub.configurationLimit = 8;
  boot.loader.systemd-boot.configurationLimit = 8;

  environment.systemPackages = [
    (pkgs.writeShellScriptBin "nixFlakes" ''
      exec ${pkgs.nixUnstable}/bin/nix --experimental-features "nix-command flakes" "$@"
    '')
  ];

  nix = {
    nixPath = [
      "nixpkgs=${sources.nixpkgs}"
      "nur=${sources.nur}"
      "arc=${sources.arcexprs}"
      "ci=${sources.ci}"
    ];
    sandboxPaths = [
      "/var/run/nscd/socket"
    ];
    binaryCaches = [ "https://arc.cachix.org" "https://kittywitch.cachix.org" "https://nix-community.cachix.org" ];
    binaryCachePublicKeys =
      [ "arc.cachix.org-1:DZmhclLkB6UO0rc0rBzNpwFbbaeLfyn+fYccuAy7YVY=" "kittywitch.cachix.org-1:KIzX/G5cuPw5WgrXad6UnrRZ8UDr7jhXzRTK/lmqyK0=" "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=" ];
    autoOptimiseStore = true;
    gc = {
      automatic = lib.mkDefault true;
      dates = lib.mkDefault "weekly";
      options = lib.mkDefault "--delete-older-than 1w";
    };
    trustedUsers = [ "root" "@wheel" ];
  };
}
