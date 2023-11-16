{
  config,
  inputs,
  pkgs,
  ...
}: let
  konawallConfig = {
    interval = 300;
    rotate = true;
    source = "konachan";
    tags = [
      "rating:s"
      "touhou"
      "score:>=50"
      "width:>=1500"
    ];
    logging = {
      file = "INFO";
      console = "DEBUG";
    };
  };
in {
  home.file."Library/Application Support/konawall/config.toml".source = (pkgs.formats.toml {}).generate "konawall-config" konawallConfig;

  launchd.agents.konawall = {
    enable = true;
    config = let
      konawallInitialize = pkgs.writeScriptBin "konawall-initialize" ''
        #!/usr/bin/env bash
        set -xeuo pipefail
        # get a temporary directory
        tmpDir=$(mktemp -d)
        # copy the repository to the temporary directory recursively without keeping the permissions from the nix store
        ${pkgs.coreutils}/bin/cp -r --no-preserve=mode,ownership "${inputs.konawall-py.outPath}" "$tmpDir/konawall"
        # change directory to the copy
        cd $tmpDir/konawall
        # install the dependencies
        ${pkgs.poetry}/bin/poetry install
        # run the package
        ${pkgs.poetry}/bin/poetry run gui
      '';
    in {
      # yeah if https://github.com/NixOS/nixpkgs/issues/233265 and https://github.com/NixOS/nixpkgs/issues/101360
      # and https://github.com/NixOS/nixpkgs/issues/105156 were ok we might be able to do this
      #Program = "${inputs.konawall-py.packages.${pkgs.system}.konawall-py}/bin/konawall";
      #ProgramArguments = ["${inputs.konawall-py.packages.${pkgs.system}.konawall-py}/bin/konawall"];
      # it's unfortunate that this has to be done this way, for the most part.
      ProgramArguments = [
        "/usr/bin/env"
        "bash"
        "${konawallInitialize}/bin/konawall-initialize"
      ];
      RunAtLoad = true;
      KeepAlive = true;
    };
  };
}
