rec {
  base = ./base.nix;
  gui = ./gui.nix;
  fvwm = ./fvwm.nix;
  sway = ./sway.nix;
  dev = ./dev.nix;
  media = ./media.nix;
  personal = ./personal.nix;

  server = { imports = [ personal ]; };
  guiFull = { imports = [ gui fvwm dev media personal ]; };
}
