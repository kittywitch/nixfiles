{ config ? { }, sources, system ? builtins.currentSystem, ... }@args:

let
  pkgs = import sources.nixpkgs { inherit config; };
  overlay = self: super: rec {
    dino = super.callPackage "${sources.qyliss-nixlib}/overlays/patches/dino" {
      inherit (super) dino;
    };

    discord = unstable.discord.override { nss = self.nss; };

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

    kat-ckb = super.ckb-next.overrideAttrs (old: rec {
      version = "0.4.4";
      src = self.fetchFromGitHub {
        owner = "ckb-next";
        repo = "ckb-next";
        rev = "v${version}";
        sha256 = "1fgvh2hsrm8vqbqq9g45skhyyrhhka4d8ngmyldkldak1fgmrvb7";
      };
      buildInputs = old.buildInputs ++ [
        self.xorg.libXdmcp
        self.qt5.qttools
        self.libsForQt5.qt5.qtx11extras
        self.libsForQt5.libdbusmenu
      ];
      patches = [
        ./kat-ckb/install-dirs.patch
        (self.substituteAll {
          name = "ckb-next-modprobe.patch";
          src = ./kat-ckb/modprobe.patch;
          kmod = self.kmod;
        })
      ];
    });

    kat-vm = super.callPackage ./kat-vm { };

    kat-glauca-dns = unstable.callPackage ./kat-glauca-dns { inherit sources; };

    kat-website = super.callPackage ./kat-website { };

    kat-weather = super.callPackage ./kat-weather { };

    kat-gpg-status = super.callPackage ./kat-gpg-status { };

    kat-tw-export = super.callPackage ./kat-tw-export { };

    kat-scrot = super.callPackage ./kat-scrot { };

    linuxPackagesFor = kernel:
      (super.linuxPackagesFor kernel).extend (_: ksuper: {
        vendor-reset =
          (super.callPackage ./vendor-reset { kernel = ksuper.kernel; }).out;
      });
  };

in (pkgs.extend (import (sources.arc-nixexprs + "/overlay.nix"))).extend overlay
