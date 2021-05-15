{ }: let
  config = import ./default.nix;
  tf = config.deploy.tf {};
  inherit (config) pkgs;
  nf-actions = config.pkgs.writeShellScriptBin "nf-actions" ''
    export START_DIR="$PWD"
    cd ${toString ./.}
    export NF_CONFIG_ROOT=${toString ./.}/ci
    NF_CONFIG_FILES=($NF_CONFIG_ROOT/hosts.nix)
    for f in "''${NF_CONFIG_FILES[@]}"; do
      echo $f
      nix run --arg config $f ci.run.gh-actions-generate
    done
    cd ${toString ./trusted}
    export TRUSTED_CONFIG_ROOT=${toString ./trusted}/ci
    TRUSTED_CONFIG_FILES=($TRUSTED_CONFIG_ROOT/{hosts,niv-cron}.nix)
    for f in "''${TRUSTED_CONFIG_FILES[@]}"; do
      echo $f
      nix run --arg config $f ci.run.gh-actions-generate
    done
    cd $START_DIR
  '';
  nf-test = config.pkgs.writeShellScriptBin "nf-test" ''
    export START_DIR="$PWD"
    cd ${toString ./.}
    export NF_CONFIG_ROOT=${toString ./.}/ci
    NF_CONFIG_FILES=($NF_CONFIG_ROOT/hosts.nix)
    for f in "''${NF_CONFIG_FILES[@]}"; do
      echo $f
      nix run --arg config $f ci.run.gh-actions-generate
    done
    cd ${toString ./trusted}
    export TRUSTED_CONFIG_ROOT=${toString ./trusted}/ci
    TRUSTED_CONFIG_FILES=($TRUSTED_CONFIG_ROOT/{hosts,niv-cron}.nix)
    for f in "''${TRUSTED_CONFIG_FILES[@]}"; do
      echo $f
      nix run --arg config $f ci.test
    done
    cd $START_DIR
  '';
in pkgs.mkShell {
  nativeBuildInputs = [
    nf-actions
    nf-test
  ] ++ config.runners.lazy.nativeBuildInputs;

  HISTFILE = toString (tf.terraform.baseDir + "/.history");
  CI_PLATFORM = "impure"; # use host's nixpkgs for more convenient testing

  shellHook = ''
    export HOME_HOSTNAME=$(hostname -s)
    export NIX_PATH="$NIX_PATH:nixfiles=${toString ./.}"
  '';
}
