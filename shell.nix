{ }: let
  config = import ./default.nix;
  tf = config.deploy.tf {};
  inherit (config) pkgs;
in pkgs.mkShell {
  nativeBuildInputs = config.runners.lazy.nativeBuildInputs;
  HISTFILE = toString (tf.terraform.baseDir + "/.history");

  CI_ROOT = toString ./.;
  CI_CONFIG_ROOT = toString ./ci;
  #CI_CONFIG = toString ./example/ci.nix
  CI_PLATFORM = "impure"; # use host's nixpkgs for more convenient testing

  shellHook = ''
    export HOME_HOSTNAME=$(hostname -s)
    export NIX_PATH="$NIX_PATH:nixfiles=${toString ./.}"

    CI_CONFIG_FILES=($CI_CONFIG_ROOT/hosts.nix)
    gh-actions-generate() {
      for f in "''${CI_CONFIG_FILES[@]}"; do
        nix run --arg config $f ci.run.gh-actions-generate
      done
    }
    test-all() {
      for f in "''${CI_CONFIG_FILES[@]}"; do
        nix run --arg config $f ci.test || break
      done
    }
  '';
}
