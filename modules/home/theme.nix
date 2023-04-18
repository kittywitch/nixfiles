{ meta, config, pkgs, lib, ... }:

/*
  This module:
  * provides a central way to change the font my system uses.
*/

with lib;

let cfg = config.nixfiles.theme; in
{
  imports = with meta; [
    modules.home.swaylock
  ];
  options.nixfiles.theme = {
    enable = mkEnableOption "kat's theme module";
    sass = {
      variables = mkOption {
        type = types.attrsOf types.str;
        default = (cfg.base16 // cfg.base16t // {
          term_font = cfg.font.termName;
          font = cfg.font.name;
          font_size = cfg.font.size_css;
        });
      };
      css_style = mkOption {
        type = types.enum [ "nested" "compressed" "compact" "expanded" ];
        default = "expanded";
      };
    };
    swaylock = mkEnableOption "use swaylock module";
    base16 = mkOption {
      type = types.attrsOf types.str;
    };
    base16t = mkOption {
      type = types.attrsOf types.str;
    };
    alpha = mkOption {
      type = types.float;
    };
    font = {
      name = mkOption {
        type = types.str;
        default = "Iosevka Nerd Font";
      };
      termName = mkOption {
        type = types.str;
        default = "Iosevka Nerd Font";
      };
      size = mkOption {
        type = types.float;
        default = 10.0;
      };
      size_css = mkOption {
        type = types.str;
        default = "${toString (cfg.font.size + 3)}px";
      };
    };
  };
  config = mkIf (cfg.enable) {
    nixfiles.theme = {
      base16 = lib.mapAttrs' (k: v: lib.nameValuePair k "#${v.hex}")
        (lib.filterAttrs (n: _: lib.hasInfix "base" n) config.base16.defaultScheme);
      base16t = lib.mapAttrs' (k: v: lib.nameValuePair "${k}t" "rgba(${toString v.red.byte}, ${toString v.green.byte}, ${toString v.blue.byte}, ${toString cfg.alpha})")
        (lib.filterAttrs (n: _: lib.hasInfix "base" n) config.base16.defaultScheme);
      alpha = 0.7;
    };

    programs.swaylock = mkIf (cfg.swaylock) {
      enable = true;
      package = pkgs.swaylock-effects-develop;
      settings = {
        screenshots = true;
        daemonize = true;
        show-failed-attempts = true;
        indicator = true;
        indicator-radius = 110;
        indicator-thickness = 8;
        font = cfg.font.name;
        font-size = cfg.font.size_css;
        clock = true;
        datestr = "%F";
        timestr = "%T";
        effect-blur = "5x2";
        fade-in = 0.2;
      };
      colors = with cfg.base16; {
        key-hl = base0C;
        separator = base01;
        line = base01;
        line-clear = base01;
        line-caps-lock = base01;
        line-ver = base01;
        line-wrong = base01;
        ring = base00;
        ring-clear = base0B;
        ring-caps-lock = base09;
        ring-ver = base0D;
        ring-wrong = base08;
        inside = base00;
        inside-clear = base00;
        inside-caps-lock = base00;
        inside-ver = base00;
        inside-wrong = base00;
        text = base05;
        text-clear = base05;
        text-caps-lock = base05;
        text-ver = base05;
        text-wrong = base05;
      };
    };

    systemd.user.services.swayidle = mkIf (cfg.swaylock) {
      Unit = {
        Description = "swayidle";
        Documentation = [ "man:swayidle(1)" ];
        PartOf = [ "graphical-session.target" ];
      };
      Service = {
        Type = "simple";
        ExecStart =
          let
            lockCommand = config.programs.swaylock.script;
          in
          ''
            ${pkgs.swayidle}/bin/swayidle -w \
            timeout 300 '${lockCommand}' \
            timeout 600 'swaymsg "output * dpms off"' \
            resume 'swaymsg "output * dpms on"' \
            before-sleep '${lockCommand}'
          '';
        RestartSec = 3;
        Restart = "always";
      };
      Install = { WantedBy = [ "sway-session.target" ]; };
    };

    lib.nixfiles.sassTemplate = { name, src }:
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
    _module.args = { inherit (config.lib) nixfiles; };
  };
}
