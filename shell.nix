{ }: let
  config = import ./default.nix;
  tf = config.deploy.tf {};
  inherit (config) pkgs;
in pkgs.mkShell {
  nativeBuildInputs = config.runners.lazy.nativeBuildInputs;
  HISTFILE = toString (tf.terraform.baseDir + "/.history");

  CI_PLATFORM = "impure"; # use host's nixpkgs for more convenient testing

  shellHook = ''
    export HOME_HOSTNAME=$(hostname -s)
    export NIX_PATH="$NIX_PATH:nixfiles=${toString ./.}"
  '';
}
