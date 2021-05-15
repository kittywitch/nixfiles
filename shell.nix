{ }: let
  config = import ./default.nix;
  tf = config.deploy.tf {};
  gh-actions-generate = config.pkgs.writeShellScriptBin "gh-actions-generate" ''
    #!/usr/bin/env bash
    export CI_ROOT=./;
    export CI_CONFIG_ROOT=./ci;
    CI_CONFIG_FILES=($CI_CONFIG_ROOT/hosts.nix)
    for f in "''${CI_CONFIG_FILES[@]}"; do
      nix run --arg config $f ci.run.gh-actions-generate
    done
  '';
  test-all = config.pkgs.writeShellScriptBin "test-all" ''
    #!/usr/bin/env bash
    export CI_ROOT=./;
    export CI_CONFIG_ROOT=./ci;
    CI_CONFIG_FILES=($CI_CONFIG_ROOT/hosts.nix)
    for f in "''${CI_CONFIG_FILES[@]}"; do
      nix run --arg config $f ci.test || break
    done
  '';
  inherit (config) pkgs;
in pkgs.mkShell {
  nativeBuildInputs = [
    gh-actions-generate
    test-all
  ] ++ config.runners.lazy.nativeBuildInputs;
  HISTFILE = toString (tf.terraform.baseDir + "/.history");

  CI_PLATFORM = "impure"; # use host's nixpkgs for more convenient testing

  shellHook = ''
    export HOME_HOSTNAME=$(hostname -s)
    export NIX_PATH="$NIX_PATH:nixfiles=${toString ./.}"
  '';
}
