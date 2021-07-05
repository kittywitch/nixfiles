{ }: let
  meta = import ./default.nix;
  config = meta;
  inherit (meta) pkgs;
  nf-actions = pkgs.writeShellScriptBin "nf-actions" ''
    export START_DIR="$PWD"
    cd ${toString ./.}
    export NF_CONFIG_ROOT=${toString ./.}/ci
    NF_CONFIG_FILES=($NF_CONFIG_ROOT/{hosts,niv-cron}.nix)
    for f in "''${NF_CONFIG_FILES[@]}"; do
      echo $f
      nix run --arg config $f ci.run.gh-actions-generate
    done
    cd ${toString ./trusted}
    export TRUSTED_CONFIG_ROOT=${toString ./trusted}/ci
    TRUSTED_CONFIG_FILES=($TRUSTED_CONFIG_ROOT/hosts.nix)
    for f in "''${TRUSTED_CONFIG_FILES[@]}"; do
      echo $f
      nix run --arg config $f ci.run.gh-actions-generate
    done
    cd $START_DIR
  '';
  nf-test = pkgs.writeShellScriptBin "nf-test" ''
    export START_DIR="$PWD"
    cd ${toString ./.}
    export NF_CONFIG_ROOT=${toString ./.}/ci
    NF_CONFIG_FILES=($NF_CONFIG_ROOT/{hosts,niv-cron}.nix)
    for f in "''${NF_CONFIG_FILES[@]}"; do
      echo $f
      nix run --arg config $f ci.test
    done
    cd ${toString ./trusted}
    export TRUSTED_CONFIG_ROOT=${toString ./trusted}/ci
    TRUSTED_CONFIG_FILES=($TRUSTED_CONFIG_ROOT/hosts.nix)
    for f in "''${TRUSTED_CONFIG_FILES[@]}"; do
      echo $f
      nix run --arg config $f ci.test
    done
    cd $START_DIR
  '';
in pkgs.mkShell {
  nativeBuildInputs = with pkgs; [
    inetutils
    nf-actions
    nf-test
  ] ++ config.runners.lazy.nativeBuildInputs;

  HISTFILE = toString (config.deploy.dataDir + "/.history");

  shellHook = ''
    export HOME_HOSTNAME=$(hostname -s)
    export HOME_UID=$(id -u)
    export NIX_PATH="$NIX_PATH:home=${toString ./.}"
  '';
}

