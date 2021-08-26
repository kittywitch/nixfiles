{ config, pkgs, lib, ... }:

/*
  This module:
  * provides a central way to change the font my system uses.
*/

with lib;

let cfg = config.kw.theme; in
{
  options.kw.theme = {
    enable = mkEnableOption "kat's theme module";
    css_style = mkOption {
      type = types.enum [ "nested" "compressed" "compact" "expanded" ];
      default = "expanded";
    };
    base16 = mkOption {
      type = types.attrsOf types.str;
    };
    alpha = mkOption {
      type = types.str;
    };
    font = {
      name = mkOption {
        type = types.str;
        default = "Cozette";
      };
      size = mkOption {
        type = types.float;
        default = 9.0;
      };
      size_css = mkOption {
        type = types.str;
        default = "${toString (cfg.font.size + 3)}px";
      };
    };
    variables = mkOption {
      type = types.attrsOf types.str;
      default = (cfg.base16 // {
        font = cfg.font.name;
        font_size = cfg.font.size_css;
        inherit (cfg) alpha;
      });
    };
  };
  config = mkIf (cfg.enable) {
    kw.theme = {
      base16 = lib.mapAttrs' (k: v: lib.nameValuePair k "#${v.hex.rgb}")
      (lib.filterAttrs (n: _: lib.hasInfix "base" n) config.lib.arc.base16.schemeForAlias.default);
      alpha = "80";
    };

    lib.kw.sassTemplate = { name, src }: let
      variables = pkgs.writeText "base-variables.sass" ''
        ${(concatStringsSep "\n" (mapAttrsToList(var: con: "\$${var}: ${con}") cfg.variables))}
      '';
      source = pkgs.callPackage ({ sass, stdenv }: stdenv.mkDerivation ({
        inherit name src variables;
        nativeBuildInputs = lib.singleton sass;
        phases = [ "buildPhase" ];
        buildPhase = ''
          cat $variables $src > src-mut.sass
          sass src-mut.sass $out --sourcemap=none --style=${cfg.css_style}
        '';
      } // cfg.variables)) {}; in {
        inherit source;
        text = builtins.readFile source;
    };
    _module.args = { inherit (config.lib) kw; };
  };
}
