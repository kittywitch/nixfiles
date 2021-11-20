{ config, lib, pkgs, sources, ... }:

{
  boot.loader.grub.configurationLimit = 8;
  boot.loader.systemd-boot.configurationLimit = 8;

  nix = {
    extraOptions = lib.optionalString (lib.versionAtLeast config.nix.package.version "2.4") ''
        experimental-features = nix-command flakes
    '';
    nixPath = [
      "nixpkgs=${sources.nixpkgs}"
      "nur=${sources.nur}"
      "arc=${sources.arcexprs}"
      "ci=${sources.ci}"
    ];
    sandboxPaths = [
      "/var/run/nscd/socket"
    ];

    binaryCaches = [ "https://arc.cachix.org" "https://kittywitch.cachix.org" "https://nix-community.cachix.org" "https://nixcache.reflex-frp.org" ];
    binaryCachePublicKeys =
      [ "arc.cachix.org-1:DZmhclLkB6UO0rc0rBzNpwFbbaeLfyn+fYccuAy7YVY=" "kittywitch.cachix.org-1:KIzX/G5cuPw5WgrXad6UnrRZ8UDr7jhXzRTK/lmqyK0=" "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=" "ryantrinkle.com-1:JJiAKaRv9mWgpVAz8dwewnZe0AzzEAzPkagE9SP5NWI=" ];
    autoOptimiseStore = true;
    gc = {
      automatic = lib.mkDefault false;
      dates = lib.mkDefault "weekly";
      options = lib.mkDefault "--delete-older-than 1w";
    };
    trustedUsers = [ "root" "@wheel" ];
  };
}
