{ lib, channels, config, ... }:
with lib; let
  gitBranch = "arc";
in {
  name = "flake-update";

  nixpkgs.args.localSystem = "x86_64-linux";

  ci = {
    version = "v0.6";
    gh-actions = {
      enable = true;
      export = true;
    };
  };


  gh-actions.env.CACHIX_SIGNING_KEY = "\${{ secrets.CACHIX_SIGNING_KEY }}";


  nix.config = {
    extra-platforms = [ "aarch64-linux" "armv6l-linux" "armv7l-linux" ];
    #extra-sandbox-paths = with channels.cipkgs; map (package: builtins.unsafeDiscardStringContext "${package}?") [bash qemu "/run/binfmt"];
  };

  environment.bootstrap = {
    archbinfmt =
      let
        makeQemuWrapper = name: ''
          mkdir -p /run/binfmt
          rm -f /run/binfmt/${name}-linux
          cat > /run/binfmt/${name}-linux << 'EOF'
          #!${channels.cipkgs.bash}/bin/sh
          exec -- ${channels.cipkgs.qemu}/bin/qemu-${name} "$@"
          EOF
          chmod +x /run/binfmt/${name}-linux
        ''; in
      channels.cipkgs.writeShellScriptBin "archbinfmt" ''
        ${makeQemuWrapper "aarch64"}
        ${makeQemuWrapper "arm"}
        echo 'extra-sandbox-paths = ${channels.cipkgs.bash} ${channels.cipkgs.qemu} /run/binfmt' >> /etc/nix/nix.conf
        echo ':aarch64-linux:M::\x7fELF\x02\x01\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\xb7\x00:\xff\xff\xff\xff\xff\xff\xff\x00\xff\xff\xff\xff\xff\xff\x00\xff\xfe\xff\xff\xff:/run/binfmt/aarch64-linux:' > /proc/sys/fs/binfmt_misc/register
        echo ':armv6l-linux:M::\x7fELF\x01\x01\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x28\x00:\xff\xff\xff\xff\xff\xff\xff\x00\xff\xff\xff\xff\xff\xff\x00\xff\xfe\xff\xff\xff:/run/binfmt/arm-linux:' > /proc/sys/fs/binfmt_misc/register
        echo ':armv7l-linux:M::\x7fELF\x01\x01\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x28\x00:\xff\xff\xff\xff\xff\xff\xff\x00\xff\xff\xff\xff\xff\xff\x00\xff\xfe\xff\xff\xff:/run/binfmt/arm-linux:' > /proc/sys/fs/binfmt_misc/register
      '';
  };

  gh-actions = {
    on =
      let
        paths = [
          "default.nix" # sourceCache
          "ci/flake-cron.nix"
          config.ci.gh-actions.path
        ];
      in
      {
        push = {
          inherit paths;
        };
        pull_request = {
          inherit paths;
        };
        schedule = [{
          cron = "0 0 * * *";
        }];
      };
    jobs = mkIf (config.id != "ci") {
      ${config.id}.step.architectures = {
        order = 201;
        name = "prepare for emulated builds";
        run = ''
          sudo $(which archbinfmt)
        '';
      };
    };
  };

  channels = {
    nixfiles.path = ../.;
    nixpkgs.path = "${channels.nixfiles.inputs.nixpkgs}";
  };

  jobs.flake-update = {
    tasks.flake-build.inputs = with channels.cipkgs;
      ci.command {
        name = "flake-update-build";
        allowSubstitutes = false;
        cache = {
          enable = false;
        };
        displayName = "flake update build";
        environment = [ "CACHIX_SIGNING_KEY" "GITHUB_REF" ];
        command =
          let
            filteredHosts = [ "tewi" ];
            nodeBuildString = concatMapStringsSep " && " (node: "nix build -Lf . network.nodes.nixos.${node}.deploy.system -o result-${node} && nix-collect-garbage -d") filteredHosts;
          in
          ''
            # ${toString builtins.currentTime}
            nix flake update

            if git status --porcelain | grep -qF flake.lock; then
              git -P diff flake.lock
              echo "checking that network.nodes.still build..." >&2
              if ${nodeBuildString}; then
                if [[ -n $CACHIX_SIGNING_KEY ]]; then
                  cachix push kittywitch result*/ &
                  CACHIX_PUSH=$!
                fi
                git add flake.lock
                export GIT_{COMMITTER,AUTHOR}_EMAIL=github@kittywit.ch
                export GIT_{COMMITTER,AUTHOR}_NAME="flake cron job"
                git commit --message="ci: flake update"
                if [[ $GITHUB_REF = refs/heads/${gitBranch} ]]; then
                  git push origin HEAD:${gitBranch}
                fi

                wait ''${CACHIX_PUSH-}
              fi
            else
              echo "no source changes" >&2
            fi
          '';
        impure = true;
      };
  };

  ci.gh-actions.checkoutOptions = {
    submodules = false;
    fetch-depth = 0;
  };

  cache.cachix = {
    arc = {
      enable = true;
      publicKey = "arc.cachix.org-1:DZmhclLkB6UO0rc0rBzNpwFbbaeLfyn+fYccuAy7YVY=";
      signingKey = null;
    };
    kittywitch = {
      enable = true;
      publicKey =
        "kittywitch.cachix.org-1:KIzX/G5cuPw5WgrXad6UnrRZ8UDr7jhXzRTK/lmqyK0=";
      signingKey = "mewp";
    };
  };
}
