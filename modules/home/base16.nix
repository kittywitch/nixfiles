{
  config,
  pkgs,
  lib,
  std,
  ...
}: let
  inherit (lib.options) mkOption;
  inherit (lib.types) attrsOf str enum;
  inherit (lib.modules) mkIf;
  inherit (std) string set tuple list;
  cfg = config.base16;
in {
  options.base16 = {
    palette = mkOption {
      type = attrsOf str;
    };
    sass = {
      variables = mkOption {
        type = attrsOf str;
        default =
          cfg.palette
          // {
            term_font = "Iosevka";
            font = "Iosevka";
            font_size = "14px";
          };
      };
      css_style = mkOption {
        type = enum ["nested" "compressed" "compact" "expanded"];
        default = "expanded";
      };
    };
  };
  config = mkIf (cfg.schemes != {}) {
    base16 = {
      palette = set.fromList (set.mapToValues (k: v:
        tuple.tuple2
          k
          "#${v.hex}"
        )
        (set.filter (n: _: string.hasPrefix "base" n)
          cfg.defaultScheme));
    };

    lib.kittywitch.sassTemplate = {
      name,
      src,
    }: let
      variables = pkgs.writeText "base-variables.sass" ''
        ${(string.concatSep "\n" (set.mapToValues (var: con: "\$${var}: ${con}") cfg.sass.variables))}
      '';
      source =
        pkgs.callPackage
        ({
          sass,
          stdenv,
        }:
          stdenv.mkDerivation {
            inherit name src variables;
            nativeBuildInputs = list.singleton pkgs.sass;
            phases = ["buildPhase"];
            buildPhase = ''
              cat $variables $src > src-mut.sass
              sass src-mut.sass $out --sourcemap=none --trace --style=${cfg.sass.css_style}
            '';
          })
        {};
    in {
      inherit source;
      text = builtins.readFile source;
    };
    _module.args = {inherit (config.lib) kittywitch;};
  };
}
