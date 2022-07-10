{ inputs, system }:
let
  meta = import ./outputs.nix { inherit inputs system; };
  config = meta;
  inherit (meta) pkgs;
  inherit (pkgs) lib;
  inherit (lib.options) optional;
  inherit (lib.attrsets) attrValues;
  nf-actions = pkgs.writeShellScriptBin "nf-actions" ''
    export START_DIR="$PWD"
    cd "${toString ./.}"
    export NF_CONFIG_ROOT=${toString ./.}/ci
    NF_CONFIG_FILES=($NF_CONFIG_ROOT/{nodes,flake-cron}.nix)
    for f in "''${NF_CONFIG_FILES[@]}"; do
      echo $f
      nix run --argstr config "$f" -f '${inputs.ci}' run.gh-actions-generate
    done
    cd $START_DIR
  '';
  nf-actions-test = pkgs.writeShellScriptBin "nf-actions-test" ''
    export START_DIR="$PWD"
    cd "${toString ./.}"
    export NF_CONFIG_ROOT=${toString ./.}/ci
    NF_CONFIG_FILES=($NF_CONFIG_ROOT/{nodes,flake-cron}.nix)
    for f in "''${NF_CONFIG_FILES[@]}"; do
      echo $f
      nix run --argstr config "$f" -f '${inputs.ci}' test
    done
    cd $START_DIR
  '';
  nf-update = pkgs.writeShellScriptBin "nf-update" ''
    nix flake update
    if [[ -n $TRUSTED ]]; then
      nix flake lock ./flake/trusted --update-input trusted
    fi
  '';
  sumireko-apply = pkgs.writeShellScriptBin "sumireko-apply" ''
    nix build ${toString ./.}#darwinConfigurations.sumireko.system
    darwin-rebuild switch --flake ${toString ./.}#sumireko
  '';
in
pkgs.mkShell {
  nativeBuildInputs = with pkgs; [
    inetutils
    nf-actions
    nf-actions-test
    nf-update
    sumireko-apply
  ] ++ config.runners.lazy.nativeBuildInputs
   ++ lib.optional (builtins.getEnv "TRUSTED" != "") (pkgs.writeShellScriptBin "bitw" ''${pkgs.rbw-bitw}/bin/bitw -p gpg://${config.network.nodes.nixos.koishi.kw.secrets.repo.bitw.source} "$@"'')
  ++ (map
    (node: writeShellScriptBin "${node.networking.hostName}-sd-img" ''
      nix build -f . network.nodes.${node.networking.hostName}.system.build.sdImage --show-trace
    '')
    (builtins.filter (node: node.system.build ? sdImage) (attrValues meta.network.nodes.nixos)))
  ++ (map
    (node: writeShellScriptBin "${node.networking.hostName}-iso-img" ''
      nix build -f . network.nodes.${node.networking.hostName}.system.build.isoImage --show-trace
    '')
    (builtins.filter (node: node.system.build ? isoImage) (attrValues meta.network.nodes.nixos)));
  shellHook = ''
    export HOME_HOSTNAME=$(hostname -s)
    export NIX_BIN_DIR=${pkgs.nix}/bin
    export HOME_UID=$(id -u)
    export HOME_USER=$(id -un)
    export CI_PLATFORM="impure"
    export NIX_PATH="$NIX_PATH:home=${toString ./.}"
    git pull
  '';
}

