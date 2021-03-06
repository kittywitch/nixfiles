{ config, lib, pkgs, sources, ... }:

{
  boot.loader.grub.configurationLimit = 8;
  boot.loader.systemd-boot.configurationLimit = 8;

  nixpkgs.config = { allowUnfree = true; };
  nix = {
    nixPath = [
      "nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixos"
      "nixpkgs-unstable=${sources.nixpkgs-unstable}"
      "nixpkgs-mozilla=${sources.nixpkgs-mozilla}"
      "NUR=${sources.NUR}"
      "arc=${sources.arc-nixexprs}"
    ];
    binaryCaches = [ "https://cache.nixos.org" "https://arc.cachix.org" ];
    binaryCachePublicKeys =
      [ "arc.cachix.org-1:DZmhclLkB6UO0rc0rBzNpwFbbaeLfyn+fYccuAy7YVY=" ];
    gc.automatic = lib.mkDefault true;
    gc.options = lib.mkDefault "--delete-older-than 1w";
    trustedUsers = [ "root" "@wheel" ];
  };
}
