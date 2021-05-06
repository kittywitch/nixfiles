rec {
  base = ./nixos/base.nix;
  gui = ./nixos/gui.nix;
  sway = ./nixos/sway.nix;
  dev = ./nixos/dev.nix;
  media = ./nixos/media.nix;
  personal = ./nixos/personal.nix;

  server = { imports = [ personal ]; };
  guiFull = { imports = [ gui sway dev media personal ]; };
}
