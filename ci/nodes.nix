{ lib, config, channels, env, ... }: with lib; {
  name = "nodes";
  ci.gh-actions.enable = true;
  ci.gh-actions.export = true;
  channels.nixfiles.path = ../.;

  nix.config.extraPlatforms = "aarch64-linux";

  gh-actions = {
    jobs.ci.step.aarch64 = {
      order = 201;
      name = "prepare for aarch64 builds";
      run = ''
        sudo aarch64binfmt
      '';
    };
  };

  # ensure sources are fetched and available in the local store before evaluating host configs
  environment.bootstrap = {
    aarch64binfmt =
      let
        makeQemuWrapper = name: ''
          mkdir -f /run/binfmt
          rm -f /run/binfmt/${name}
          cat > /run/binfmt/${name} << 'EOF'
          #!${channels.cipkgs.bash}/bin/sh
          exec -- ${channels.cipkgs.qemu}/bin/qemu-${name} "$@"
          EOF
          chmod +x /run/binfmt/${name}
        ''; in
      channels.cipkgs.writeShellScriptBin "aarch64binfmt" ''
        ${makeQemuWrapper "aarch64"}
        mount binfmt_misc -t binfmt_misc /proc/sys/fs/binfmt_misc
        echo ':aarch64-linux:M::\x7fELF\x02\x01\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\xb7\x00:\xff\xff\xff\xff\xff\xff\xff\x00\xff\xff\xff\xff\xff\xff\x00\xff\xfe\xff\xff\xff:/run/binfmt/aarch64:' > /proc/sys/fs/binfmt_misc/register
      '';
    sourceCache = channels.cipkgs.runCommand "sources"
      {
        srcs = attrNames channels.nixfiles.sourceCache.local;
      } ''
      mkdir -p $out/share/sources
      ln -s $srcs $out/share/sources/
    '';
  };

  jobs =
    let
      main = (import ../.);
      hosts = main.network.nodes;
      targets = main.deploy.targets;
      enabledTargets = filterAttrs (_: v: v.enable) main.deploy.targets;
      enabledHosts = concatLists (mapAttrsToList (targetName: target: target.nodeNames) enabledTargets);
    in
    mapAttrs' (k: nameValuePair "${k}") (genAttrs enabledHosts (host: {
      tasks.${host}.inputs = channels.nixfiles.network.nodes.${host}.deploy.system;
    }));

  ci.gh-actions.checkoutOptions.submodules = false;
  cache.cachix.arc = {
    enable = true;
    publicKey = "arc.cachix.org-1:DZmhclLkB6UO0rc0rBzNpwFbbaeLfyn+fYccuAy7YVY=";
  };
  cache.cachix.kittywitch = {
    enable = true;
    publicKey = "kittywitch.cachix.org-1:KIzX/G5cuPw5WgrXad6UnrRZ8UDr7jhXzRTK/lmqyK0=";
    signingKey = "mewp";
  };
}
