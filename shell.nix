{}:
let
  meta = import ./default.nix;
  config = meta;
  inherit (meta) pkgs;
  inherit (pkgs) lib;
  fixedSources = removeAttrs config.sources [ "__functor" ];
  nf-update = pkgs.writeShellScriptBin "nf-update" ''
    TEMP=$(mktemp -d)
    git init -q $TEMP
    ${pkgs.lib.concatStringsSep "\n" (pkgs.lib.mapAttrsToList (source: spec: let
              update = "niv update ${source}";
              fetch = "timeout 30 git -C $TEMP fetch -q --depth 1 ${spec.repo} ${spec.branch}:source-${source}";
              revision = "$(git -C $TEMP show-ref -s source-${source})";
              isGit = pkgs.lib.hasPrefix "https://" spec.repo or "";
              git = ''
                if ${fetch}; then
                  echo "${source}:${spec.branch} HEAD at ${revision}" >&2
                  ${update} -r ${revision} || true
                else
                  echo "failed to fetch latest revision from ${spec.repo}" >&2
                fi
              '';
              auto = "${update} || true";
            in if isGit then git else auto) fixedSources)}
  '';
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
    nf-update
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

