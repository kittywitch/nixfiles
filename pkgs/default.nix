{ sources, system ? builtins.currentSystem, ... }@args:

let
  liboverlay = self: super: {
    lib = super.lib.extend (self: super: import ./lib
    {
      inherit super;
      lib = self;
      isOverlayLib = true;
    }
    );
  };
  overlay = self: super: rec {
    dino = super.dino.overrideAttrs (
    { patches ? [], ... }: {
      patches = patches ++ [
        ./dino/0001-add-an-option-to-enable-omemo-by-default-in-new-conv.patch
      ];
    }
    );

      discord = super.discord.override { nss = self.nss; };

      ncmpcpp = super.ncmpcpp.override {
        visualizerSupport = true;
        clockSupport = true;
      };

      waybar = super.waybar.override { pulseSupport = true; };

      nur = import sources.nur {
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

        linuxPackagesFor = kernel: (super.linuxPackagesFor kernel).extend (_: ksuper: {
          zfsUnstable = ksuper.zfsUnstable.overrideAttrs (old: { meta = old.meta // { broken = false; }; });
        });

        obs-studio = super.obs-studio.override { pipewireSupport = true; };

        libreelec-dvb-firmware = self.callPackage ./libreelec-dvb-firmware { };

        nerdfonts = super.nerdfonts.override { fonts = [ "Iosevka" ]; };

        konawall = super.konawall.overide { swaySupport = true; };

        imv = super.imv.override {
          withBackends = [ "freeimage" "libjpeg" "libpng" "librsvg" "libnsgif" "libheif" "libtiff" ];
        };

        kat-glauca-dns = self.callPackage ./kat-glauca-dns { };

        wezterm-terminfo = self.callPackage ./wezterm-terminfo { inherit (self) ncurses; };

        kat-website = self.callPackage ./kat-website { };

        kat-weather = self.callPackage ./kat-weather { };

        kat-gpg-status = self.callPackage ./kat-gpg-status { };

        kat-tw-export = self.callPackage ./kat-tw-export { };

        kat-scrot = self.callPackage ./kat-scrot { };

      } // super.lib.optionalAttrs (builtins.pathExists ../config/trusted/pkgs)
      (import ../config/trusted/pkgs { inherit super self; });
    pkgs = import sources.nixpkgs {
    overlays = [
      overlay
      liboverlay
      (import (sources.nixexprs + "/overlay.nix"))
    ];
    config = {
      allowUnfree = true;
      permittedInsecurePackages = [
        "ffmpeg-2.8.17"
      ];
    };
  };
in pkgs
