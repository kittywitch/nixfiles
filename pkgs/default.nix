{ config ? { }, sources, system ? builtins.currentSystem, ... }@args:

let
  pkgs = import sources.nixpkgs { inherit config; };
  overlay = self: super:
    rec {

      dino =
        super.callPackage "${sources.qyliss-nixlib}/overlays/patches/dino" {
          inherit (super) dino;
        };

      discord = super.discord.override { nss = self.nss; };

      ncmpcpp = super.ncmpcpp.override {
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

      screenstub = super.callPackage ./screenstub { };

      buildFirefoxXpiAddon =
        { pname, version, addonId, url, sha256, meta, ... }:
        pkgs.stdenv.mkDerivation {
          name = "${pname}-${version}";

          inherit meta;

          src = builtins.fetchurl { inherit url sha256; };

          preferLocalBuild = true;
          allowSubstitutes = false;

          buildCommand = ''
            dst="$out/share/mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}"
            mkdir -p "$dst"
            install -v -m644 "$src" "$dst/${addonId}.xpi"
          '';
        };

      obs-studio = super.obs-studio.override { pipewireSupport = true; };

      libreelec-dvb-firmware = self.callPackage ./libreelec-dvb-firmware { };

      nerdfonts = super.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; };

      hextorgba =
        (import ../lib/colorhelpers.nix { inherit (super) lib; }).hextorgba;

      konawall = super.konawall.overide { swaySupport = true; };

      ff-sponsorblock = self.callPackage ./ff-sponsorblock { };

      kat-glauca-dns = self.callPackage ./kat-glauca-dns { };

      kat-website = self.callPackage ./kat-website { };

      kat-weather = self.callPackage ./kat-weather { };

      kat-gpg-status = self.callPackage ./kat-gpg-status { };

      kat-tw-export = self.callPackage ./kat-tw-export { };

      kat-scrot = self.callPackage ./kat-scrot { };

    } // super.lib.optionalAttrs (builtins.pathExists ../trusted/pkgs)
      (import ../trusted/pkgs { inherit super self; });

in
(pkgs.extend (import (sources.arc-nixexprs + "/overlay.nix"))).extend overlay
