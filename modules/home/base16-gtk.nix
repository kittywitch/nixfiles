{ config, pkgs, lib, ... }: let
inherit (lib.types) bool enum str int submodule oneOf attrsOf listOf package;
inherit (lib.options) mkEnableOption mkOption;
inherit (lib.strings) optionalString concatStringsSep toUpper hasInfix;
inherit (lib.attrsets) mapAttrsToList mapAttrs attrValues;
inherit (pkgs.stdenv) mkDerivation;
inherit (lib.modules) mkIf mkDefault;
cfg = config.base16.gtk.settings;
bcfg = config.base16.gtk;
in {
	options = {
		base16.gtk = {
			enable = mkEnableOption "Enable GTK theme generation";
			packages = {
				icons = mkOption {
					type = attrsOf package;
				};
				themes = mkOption {
					type = attrsOf package;
				};
			};
			settings = mkOption {
				type = attrsOf (submodule {
					freeformType = attrsOf (oneOf [bool str int]);
					options = {
						name = mkOption {
							description = "Name of the theme";
							type = str;
							default = ''"${config.base16.defaultSchemeName}"'';
						};
						theme_style = mkOption {
							description = "What GTK theme do we use as the base for generating the resulting base16 GTK theme";
							type = enum ["materia" "oomox"];
							default = "oomox";
						};
						roundness = mkOption {
							description = "GTK theme roundness";
							type = int;
							default = 2;
						};
						spacing = mkOption {
							description = "GTK theme spacing";
							type = int;
							default = 3;
						};
						outline_width = mkOption {
							description = "GTK outline width";
							type = int;
							default = 1;
						};
						button_outline_offset = mkOption {
							description = "GTK theme button outline offset";
							type = int;
							default = -3;
						};
						button_outline_width = mkOption {
							description = "GTK theme button outline width";
							type = int;
							default = 1;
						};
						icon_style = mkOption {
							description = "What icon theme do we use as the base for generating the resulting base16 color templated icon theme";
							type = enum ["numix" "archdroid" "gnomecolors" "papirus" "suruplus" "suruplus_aspromauros"];
							default = "archdroid";
						};
						numix_style = mkOption {
							description = "If you chose numix for base16.gtk.icons, this chooses the Numix icon theme sub-style";
							type = enum [ 0 1 2 3 4 5 ];
							default = 0;
						};
						suruplus_gradient_enabled = mkOption {
							description = "If you chose suruplus for base16.gtk.icons, this chooses to enable the gradient on it";
							type = bool;
							default = false;
						};
						base16_generate_dark = mkOption {
							description = "Choose whether to invert the GUI colours";
							type = bool;
							default = true;
						};
					};
				});
			};
		};
	};
	config = mkIf bcfg.enable (let
			oomoxPath = "${pkgs.oomox}/lib/share/oomox/plugins";
			iconPathSelector = icon_style: {
				archdroid = "icons_archdroid/archdroid-icon-theme/change_color.sh";
				gnomecolors = "icons_gnomecolors/gnome-colors-icon-theme/change_color.sh";
			}.${icon_style} or "icons_${icon_style}/change_color.sh";
			themePathSelector = theme_style: {
				materia = "theme_materia/materia-theme/change_color.sh";
			}.${theme_style} or "theme_${theme_style}/change_color.sh";
			iconsTheme = icon_style: {
				numix = "numix_icons";
				suruplus = "icons_suru";
				suruplus_aspromauros = "icons_suruplus_aspromauros";
				archdroid = "archdroid";
				gnomecolors = "gnome_colors";
				papirus = "papirus_icons";
			}.${icon_style};
			configForScheme = schemeName: scheme: let
				schemeSettings = cfg.${schemeName} or cfg.default;
				keyValues = mapAttrsToList (k: v: let
				typeHandler = {
					"string" = if hasInfix "base" v then scheme.${v}.hex else v;
					"bool" = if v == true then "True" else "False";
					"int" = toString v;
				}.${builtins.typeOf v};
				keyHandler = {
					"icon_style" = iconsTheme v;
				}.${k} or typeHandler;
				in "${toUpper k}=${keyHandler}") schemeSettings;
			in ''
			${concatStringsSep "\n" keyValues}
		'';
		configForSchemes = mapAttrs configForScheme config.base16.schemes;
		configFilesForSchemes = mapAttrs (k: v: pkgs.writeText "oomox-config-${k}" v) configForSchemes;
		iconPackageForScheme = schemeName: schemeConfigFile: let
			schemeConfig = cfg.${schemeName} or cfg.default;
		in with pkgs; mkDerivation rec {
			name = "icons-${cfg.${schemeName}.icon_style or cfg.default.icon_style}-${schemeName}";
          src = fetchFromGitHub {
            owner = "themix-project";
            repo = "oomox";
            rev = "1.14";
            sha256 = "0zk2q0z0n64kl6my60vkq11gp4mc442jxqcwbi4kl108242izpjv";
            fetchSubmodules = true;
          };
          nativeBuildInputs = [ glib libxml2 bc ];
          buildInputs = [ gnome.gnome-themes-extra gdk-pixbuf librsvg pkgs.sassc pkgs.inkscape pkgs.optipng ];
          propagatedUserEnvPkgs = [ gtk-engine-murrine ];
			installPhase = ''
				export HOME=./
				mkdir -p ./.icons
				patchShebangs plugins/${iconPathSelector schemeConfig.icon_style}
				plugins/${iconPathSelector schemeConfig.icon_style} ${schemeConfigFile} \
					-o ${schemeConfig.icon_style}-$name
				mkdir -p $out/share/icons/${schemeConfig.icon_style}-$name
				mv ./.icons/* $out/share/icons
			'';
		};
		themePackageForScheme = schemeName: schemeConfigFile: let
			schemeConfig = cfg.${schemeName} or cfg.default;
		in with pkgs; mkDerivation rec {
				name = "theme-${cfg.${schemeName}.theme_style or cfg.default.theme_style}-${schemeName}";
          src = fetchFromGitHub {
            owner = "themix-project";
            repo = "oomox";
            rev = "1.14";
            sha256 = "0zk2q0z0n64kl6my60vkq11gp4mc442jxqcwbi4kl108242izpjv";
            fetchSubmodules = true;
          };
          nativeBuildInputs = [ glib libxml2 bc ];
          buildInputs = [ gnome.gnome-themes-extra gdk-pixbuf librsvg pkgs.sassc pkgs.inkscape pkgs.optipng ];
          propagatedUserEnvPkgs = [ gtk-engine-murrine ];
			installPhase = ''
				export HOME=./
				mkdir -p $out/share/themes/${schemeConfig.theme_style}-$name
				patchShebangs plugins/theme_${schemeConfig.theme_style}
				plugins/${themePathSelector schemeConfig.theme_style} \
					--hidpi False -t $out/share/themes -m all --output ${schemeConfig.theme_style}-$name ${schemeConfigFile}
			'';
		};
		themePackagesForSchemes = mapAttrs (k: v: themePackageForScheme k v) configFilesForSchemes;
		iconPackagesForSchemes = mapAttrs (k: v: iconPackageForScheme k v) configFilesForSchemes;
in {
		base16.gtk =  {
			packages = {
				themes = themePackagesForSchemes;
				icons = iconPackagesForSchemes;
			};
			settings.default = mapAttrs (_: mkDefault) {
			base16_invert_terminal = false;
			base16_mild_terminal = false;
			terminal_theme_accuracy = 128;
			terminal_theme_auto_bgfg = true;
			terminal_theme_extend_palette = false;
			terminal_theme_mode = "manual";
			unity_default_launcher_style = false;
			suruplus_gradient1 = "3623c";
			suruplus_gradient2 = "base0E";
			caret1_fg = "base07";
			caret2_fg = "base07";
			terminal_background = "base00";
			terminal_foreground = "base05";
			terminal_cursor = "base05";
			terminal_color0 = "base01";
			terminal_color1 = "base08";
			terminal_color2 = "base0B";
			terminal_color3 = "base09";
			terminal_color4 = "base0D";
			terminal_color5 = "base0E";
			terminal_color6 = "base0C";
			terminal_color7 = "base06";
			terminal_color8 = "base02";
			terminal_color9 = "base08";
			terminal_color10 = "base0B";
			terminal_color11 = "base0A";
			terminal_color12 = "base0D";
			terminal_color13 = "base0E";
			terminal_color14 = "base0C";
			terminal_color15 = "base07";
			bg = "base01";
			fg = "base06";
			hdr_bg = "base00";
			hdr_fg = "base05";
			sel_bg = "base0E";
			sel_fg = "base00";
			accent_bg = "base0E";
			txt_bg = "base02";
			txt_fg = "base07";
			btn_bg = "base00";
			btn_fg = "base05";
			hdr_btn_bg = "base01";
			hdr_btn_fg = "base05";
			wm_border_focus = "base0E";
			wm_border_unfocus = "base00";
			spotify_proto_bg = "base00";
			spotify_proto_fg = "base05";
			spotify_proto_sel = "base0E";
			icons_light_folder = "base0D";
			icons_light = "base0D";
			icons_medium = "base0E";
			icons_dark = "base00";
			icons_symbolic_panel = "base06";
			icons_symbolic_action = "3623c";
			icons_archdroid = "base0E";
		};
		};
		home.packages = (attrValues iconPackagesForSchemes) ++ (attrValues themePackagesForSchemes);
	});
}
