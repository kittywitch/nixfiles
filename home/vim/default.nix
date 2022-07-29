{ config, lib, pkgs, nixos, ... }:

let
inherit (lib.modules) mkIf;
inherit (lib.strings) concatStringsSep fixedWidthNumber hasInfix;
inherit (lib.attrsets) mapAttrs filterAttrs;
packDir = builtins.toString(pkgs.vimUtils.packDir config.programs.neovim.generatedConfigViml.configure.packages);
initLua = pkgs.substituteAll ({
	name = "init.lua";
	src = ./init.lua;
	inherit packDir;
	base16ShellPath = config.base16.shell.package;
	defaultSchemeName = config.base16.defaultSchemeName;
	defaultSchemeSlug = config.base16.defaultScheme.slug;
} // mapAttrs (_: col: fixedWidthNumber 2 col.ansiIndex)
	(filterAttrs (var: _: hasInfix "base" var) config.base16.defaultScheme));
in {
	home.sessionVariables = mkIf config.programs.neovim.enable { EDITOR = "nvim"; };

	programs.neovim = {
		enable = true;
		vimAlias = true;
		viAlias = true;
		plugins = with pkgs.vimPlugins; [
# Libraries
			plenary-nvim
# Disables and re-enables highlighting when searching
				vim-cool
# Colour highlighting
				vim-hexokinase
# Git porcelain
				vim-fugitive
# Start screen
				vim-startify
# Re-open with cursor at the same place
				vim-lastplace
# Status Bar
				lualine-nvim
# EasyMotion Equivalent
				hop-nvim
# org-mode for vim
				neorg
# base16
				config.base16.vim.plugin
# Fonts
				nvim-web-devicons
# Completion
				nvim-cmp
# Fuzzy Finder
				telescope-nvim
# Buffers
				bufferline-nvim
# Language Server
				nvim-lspconfig
				(pkgs.vimPlugins.nvim-treesitter.withPlugins (plugins: with pkgs.tree-sitter-grammars; [
					tree-sitter-c
					tree-sitter-lua
					tree-sitter-rust
					tree-sitter-bash
					tree-sitter-css
					tree-sitter-dockerfile
					tree-sitter-go
					tree-sitter-hcl
					tree-sitter-html
					tree-sitter-javascript
					tree-sitter-markdown
					tree-sitter-nix
					tree-sitter-norg
					tree-sitter-python
					tree-sitter-regex
					tree-sitter-scss
				]))
# Treesitter Plugins
				nvim-ts-rainbow
				nvim-treesitter-context
				twilight-nvim
				];
		extraPackages = with pkgs; [
# For nvim-lspconfig, Terraform Language Server
			terraform-ls
# For tree-sitter
				tree-sitter
				nodejs
				clang
				clangStdenv.cc
		];
	};
	xdg.configFile."nvim/init.lua".source = initLua;
}
