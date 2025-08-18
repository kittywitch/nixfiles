_: {
  projectRootFile = "flake.nix";
  programs = {
    alejandra.enable = true;
    deadnix.enable = true;
    statix.enable = true;
    terraform.enable = true;
    shellcheck.enable = true;
    beautysh.enable = true;
  };
  settings.formatter.shellcheck.excludes = [
    ".envrc"
    "tf/.envrc"
  ];
}
