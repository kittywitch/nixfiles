{ lib, channels, config, ... }:
with lib; {
  name = "flake-update";
  ci = {
    version = "nix2.4";
    gh-actions = {
      enable = true;
      export = true;
    };
  };


  gh-actions.env.OPENSSH_PRIVATE_KEY = "\${{ secrets.OPENSSH_PRIVATE_KEY }}";
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

  environment.test = {
    inherit (channels.cipkgs) cachix;
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
        environment = [ "OPENSSH_PRIVATE_KEY" "CACHIX_SIGNING_KEY" "GITHUB_REF" ];
        command =
          let
            main = (import ../.);
            hosts = main.network.nodes;
            targets = main.deploy.targets;
            enabledTargets = filterAttrs (_: v: v.enable) main.deploy.targets;
            enabledHosts = concatLists (mapAttrsToList (targetName: target: target.nodeNames) enabledTargets);
            filteredHosts = subtractLists enabledHosts [ "daiyousei" "shinmyoumaru" ];
            hostBuildString = concatMapStringsSep " && " (host: "nix build -Lf . network.nodes.${host}.deploy.system -o result-${host} && nix-collect-garbage -d") filteredHosts;
          in
          ''
            # ${toString builtins.currentTime}
            if [[ -n $OPENSSH_PRIVATE_KEY ]]; then
              mkdir ~/.ssh
              echo "$OPENSSH_PRIVATE_KEY" > ~/.ssh/id_rsa
              chmod 0600 ~/.ssh/id_rsa
            fi

            ${concatStringsSep "\n" (mapAttrsToList (n: v: "nix flake --update-input ${n}") channels.nixfiles.inputs)}

            if git status --porcelain | grep -qF flake.lock; then
              git -P diff flake.lock
              echo "checking that network.nodes.still build..." >&2
              if ${hostBuildString}; then
                if [[ -n $CACHIX_SIGNING_KEY ]]; then
                  nix build --no-link -Lf . sourceCache.all
                  cachix push kittywitch $(nix eval --raw -f . sourceCache.allStr)

                  cachix push kittywitch result*/ &
                  CACHIX_PUSH=$!
                fi
                if [[ -n $OPENSSH_PRIVATE_KEY ]]; then
                  git add nix/sources.json
                  export GIT_{COMMITTER,AUTHOR}_EMAIL=github@kittywit.ch
                  export GIT_{COMMITTER,AUTHOR}_NAME="flake cron job"
                  git commit --message="ci: flake update"
                  if [[ $GITHUB_REF = refs/heads/main ]]; then
                    GIT_SSH_COMMAND="ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no" \
                      git push ssh://gitea@git.kittywit.ch:62954/kat/nixfiles.git HEAD:main
                  fi
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

  ci.gh-actions.checkoutOptions.submodules = false;

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
