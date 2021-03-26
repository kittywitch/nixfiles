{ config ? { }, sources, system ? builtins.currentSystem, ... }@args:

let
  pkgs = import sources.nixpkgs { inherit config; };
  overlay = self: super: rec {
    dino = super.callPackage "${sources.qyliss-nixlib}/overlays/patches/dino" {
      inherit (super) dino;
    };

    discord = unstable.discord.override { nss = self.nss_latest; };

    lib = super.lib.extend
      (self: super: { deployEmbedFuckery = txt: "__FUCKERY__" + txt; });

    ncmpcpp = unstable.ncmpcpp.override {
      visualizerSupport = true;
      clockSupport = true;
    };

    waybar = super.waybar.override { pulseSupport = true; };

    notmuch = super.callPackage ./notmuch { inherit (super) notmuch; };

    unstable = import sources.nixpkgs-unstable { inherit (self) config; };
    nur = import sources.NUR {
      nurpkgs = self;
      pkgs = self;
    };

    weechatScripts = super.weechatScripts // {
      weechat-title = (super.callPackage ./weechat-title { });
    };

    screenstub = unstable.callPackage ./screenstub { };

    kat-weather = super.callPackage ./kat-weather { };

    kat-gpg-status =super.callPackage ./kat-gpg-status { };

    linuxPackagesFor = kernel:
      (super.linuxPackagesFor kernel).extend (_: ksuper: {
        vendor-reset =
          (super.callPackage ./vendor-reset { kernel = ksuper.kernel; }).out;
      });
  };

in (pkgs.extend (import (sources.arc-nixexprs + "/top-level.nix"))).extend
overlay
