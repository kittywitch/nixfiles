{ pkgs, ... }: {
  projectRootFile = "flake.nix";
  programs = {
    alejandra.enable = true;
    terraform.enable = true;
    beautysh.enable = true;
  };
}
