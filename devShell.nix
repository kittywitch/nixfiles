{ inputs, system }:
let
  meta = import ./outputs.nix { inherit inputs system; };
  config = meta;
  inherit (meta) pkgs;
  inherit (pkgs) lib;
  nf-actions = pkgs.writeShellScriptBin "nf-actions" ''
    export START_DIR="$PWD"
    cd "${toString ./.}"
    export NF_CONFIG_ROOT=${toString ./.}/ci
    NF_CONFIG_FILES=($NF_CONFIG_ROOT/{nodes,niv-cron}.nix)
    for f in "''${NF_CONFIG_FILES[@]}"; do
      echo $f
      nix run --argstr config "$f" ci.run.gh-actions-generate
    done
    cd $START_DIR
  '';
  nf-actions-test = pkgs.writeShellScriptBin "nf-actions-test" ''
    export START_DIR="$PWD"
    cd "${toString ./.}"
    export NF_CONFIG_ROOT=${toString ./.}/ci
    NF_CONFIG_FILES=($NF_CONFIG_ROOT/{nodes,niv-cron}.nix)
    for f in "''${NF_CONFIG_FILES[@]}"; do
      echo $f
      nix run --argstr config "$f" ci.test
    done
    cd $START_DIR
  '';
in
with lib; pkgs.mkShell {
  nativeBuildInputs = with pkgs; [
    inetutils
    nf-actions
    nf-actions-test
  ] ++ config.runners.lazy.nativeBuildInputs
  ++ (map
    (node: writeShellScriptBin "${node.networking.hostName}-sd-img" ''
      nix build -f . network.nodes.${node.networking.hostName}.system.build.sdImage --show-trace
    '')
    (filter (node: node.system.build ? sdImage) (attrValues meta.network.nodes)))
  ++ (map
    (node: writeShellScriptBin "${node.networking.hostName}-iso-img" ''
      nix build -f . network.nodes.${node.networking.hostName}.system.build.isoImage --show-trace
    '')
    (filter (node: node.system.build ? isoImage) (attrValues meta.network.nodes)));
  shellHook = ''
    export HOME_HOSTNAME=$(hostname -s)
    export HOME_UID=$(id -u)
    export HOME_USER=$(id -un)
    export CI_PLATFORM="impure"
    export NIX_PATH="$NIX_PATH:home=${toString ./.}"
    git pull
  '';
}

