{ config, pkgs, lib, ... }: let
  inherit (lib.types) attrsOf str enum;
  inherit (lib.modules) mkIf;
  cfg = config.base16;
in with lib; {
  options.base16 = {
    palette = mkOption {
      type = attrsOf str;
    };
    palette' = mkOption {
      type = attrsOf str;
    };
    sass = {
      variables = mkOption {
        type = attrsOf str;
        default = (cfg.palette // cfg.palette' // {
          term_font = "Iosevka Comfy";
          font = "Iosevka Comfy";
          font_size = "12px";
        });
      };
      css_style = mkOption {
        type = enum [ "nested" "compressed" "compact" "expanded" ];
        default = "expanded";
      };
    };
  };
  config = mkIf (cfg.schemes != {}) {
    base16 = {
    # TODO: convert to std
    palette = lib.mapAttrs' (k: v: 
      lib.nameValuePair
        k
        "#${v.hex}") 
        (lib.filterAttrs (n: _: lib.hasInfix "base" n)
      cfg.defaultScheme);
    palette' = lib.mapAttrs' (k: v:
      lib.nameValuePair
        "${k}t"
        "rgba(${toString v.red.byte}, ${toString v.green.byte}, ${toString v.blue.byte}, ${toString 0.7})")
        (lib.filterAttrs (n: _: lib.hasInfix "base" n)
      cfg.defaultScheme);
    };

    lib.kittywitch.sassTemplate = { name, src }:
      let
        variables = pkgs.writeText "base-variables.sass" ''
          ${(concatStringsSep "\n" (mapAttrsToList(var: con: "\$${var}: ${con}") cfg.sass.variables))}
        '';
        source = pkgs.callPackage
          ({ sass, stdenv }: stdenv.mkDerivation {
            inherit name src variables;
            nativeBuildInputs = lib.singleton sass;
            phases = [ "buildPhase" ];
            buildPhase = ''
              cat $variables $src > src-mut.sass
              sass src-mut.sass $out --sourcemap=none --trace --style=${cfg.sass.css_style}
            '';
          })
          { };
      in
      {
        inherit source;
        text = builtins.readFile source;
      };
    _module.args = { inherit (config.lib) kittywitch; };
  };
}
