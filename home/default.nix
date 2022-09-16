{ lib, tree, ... }:  let
  wrapImports = imports: lib.mapAttrs
    (_: paths: { config, ... }: {
      config.home-manager.users.kat = {
        imports = lib.singleton paths;
      };
    })
    imports;
  dirImports = wrapImports tree.prev;
  serviceImports = wrapImports tree.prev.services;
in
  dirImports // {
    base = {
      imports = with dirImports; [
        base16
        shell
        vim
        secrets
        state
        dconf
      ];
    };
    gui = {
      imports = with dirImports; [
        gui
				wezterm
        firefox
        konawall
        ranger
        xkb
        gpg
        sway
        mako
        gammastep
        wofi
        waybar
        xdg
        fonts
        media
        obs
        mpv
        syncplay
        gtk
        qt
      ];
		};
    work = {
			imports = with dirImports; [
			work
			wezterm
			emacs
			];
		};

  services = serviceImports;
}
