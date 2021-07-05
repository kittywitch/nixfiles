rec {
  base = ./base.nix;
  gui = ./gui.nix;
  sway = ./sway.nix;
  dev = ./dev.nix;
  media = ./media.nix;
  personal = ./personal.nix;

  server = { imports = [ personal ]; };
  guiFull = { imports = [ gui sway dev media personal ]; };
}
