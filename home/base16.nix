{ config, pkgs, lib, ... }:

{
	kw.theme.enable = true;

	base16 = {
		vim.enable = false;
		gtk = {
			settings.default = {
				icon_style = "numix";
				theme_style = "oomox";
			};
		};
 vim.template = data: let
        drv = pkgs.base16-templates.vim.withTemplateData data;
      in drv.overrideAttrs (old: {
        src = pkgs.fetchFromGitHub {
          repo = "base16-vim";
          owner = "fnune";
          rev = "52e4ce93a6234d112bc88e1ad25458904ffafe61";
          sha256 = "10y8z0ycmdjk47dpxf6r2pc85k0y19a29aww99vgnxp31wrkc17h";
        };
        patches = old.patches or [ ] ++ [
          (pkgs.fetchurl {
            # base16background=none
            url = "https://github.com/arcnmx/base16-vim/commit/fe16eaaa1de83b649e6867c61494276c1f35c3c3.patch";
            sha256 = "1c0n7mf6161mvxn5xlabhyxzha0m1c41csa6i43ng8zybbspipld";
          })
          (pkgs.fetchurl {
            # fix unreadable error highlights under cursor
            url = "https://github.com/arcnmx/base16-vim/commit/807e442d95c57740dd3610c9f9c07c9aae8e0995.patch";
            sha256 = "1l3qmk15v8d389363adkmfg8cpxppyhlk215yq3rdcasvw7r8bla";
          })
        ];
      });
		shell.enable = true;
		schemes = lib.mkMerge [ {
			light = "atelier.atelier-cave-light";
			dark = "atelier.atelier-cave";
		} {
			dark.ansi.palette.background.alpha = "ee00";
			light.ansi.palette.background.alpha = "d000";
		} ];
		defaultSchemeName = "dark";
	};
}
