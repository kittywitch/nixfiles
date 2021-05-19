{ lib, channels, config, ... }:
with lib; {
  name = "niv-update";
  ci.gh-actions.enable = true;
  ci.gh-actions.export = true;

  gh-actions.env.OPENSSH_PRIVATE_KEY = "\${{ secrets.OPENSSH_PRIVATE_KEY }}";
  gh-actions.env.CACHIX_SIGNING_KEY = "\${{ secrets.CACHIX_SIGNING_KEY }}";

  gh-actions = {
    on = let
      paths = [
        "default.nix" # sourceCache
        "ci/niv-cron.nix" config.ci.gh-actions.path
      ];
    in {
      push = {
        inherit paths;
      };
      pull_request = {
        inherit paths;
      };
      schedule = [ {
        cron = "0 */6 * * *";
      } ];
    };
  };

  channels = {
    nixfiles.path = ../.;
    nixpkgs.path = "${channels.nixfiles.sources.nixpkgs}";
  };

  environment.test = {
    inherit (channels.cipkgs) cachix;
    inherit (channels.nixpkgs) niv;
  };

  jobs.niv-update = {
      tasks.niv-build.inputs = with channels.cipkgs;
        ci.command {
          name = "niv-update-build";
          displayName = "niv update build";
          environment = [ "OPENSSH_PRIVATE_KEY" "CACHIX_SIGNING_KEY" ];
          command = ''
            if [[ -n $OPENSSH_PRIVATE_KEY ]]; then
              mkdir ~/.ssh
              echo "$OPENSSH_PRIVATE_KEY" > ~/.ssh/id_rsa
              chmod 0600 ~/.ssh/id_rsa
            fi

            git init -q sources
            ${concatStringsSep "\n" (mapAttrsToList (source: spec: let
              update = "niv update ${source}";
              fetch = "timeout 30 git -C sources fetch -q --depth 1 ${spec.repo} ${spec.branch}:source-${source}";
              revision = "$(git -C sources show-ref -s source-${source})";
              isGit = hasPrefix "https://" spec.repo or "";
              git = ''
                if ${fetch}; then
                  echo "${source}:${spec.branch} HEAD at ${revision}" >&2
                  ${update} -r ${revision} || true
                else
                  echo "failed to fetch latest revision from ${spec.repo}" >&2
                fi
              '';
              auto = "${update} || true";
            in if isGit then git else auto) channels.nixfiles.sources)}

            if git status --porcelain | grep -qF nix/sources.json; then
              git -P diff nix/sources.json
              nix build --no-link -Lf . sourceCache.local
              echo "checking that hosts still build..." >&2
              if nix build -Lf . hosts.{athame,yule,samhain}.config.system.build.toplevel; then
                if [[ -n $CACHIX_SIGNING_KEY ]]; then
                  nix build --no-link -Lf . sourceCache.all
                  cachix push kittywitch $(nix eval -f . sourceCache.allStr)

                  cachix push kittywitch $(readlink result*/) &
                  CACHIX_PUSH=$!
                fi
                if [[ -n $OPENSSH_PRIVATE_KEY ]]; then
                  git add nix/sources.json
                  export GIT_{COMMITTER,AUTHOR}_EMAIL=kat@kittywit.ch
                  export GIT_{COMMITTER,AUTHOR}_NAME=kat witch
                  git commit --message="ci: niv update"
                  if [[ $GITHUB_REF = refs/heads/main ]]; then
                    GIT_SSH_COMMAND="ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no" \
                      git push ssh://gitea@git.kittywit.ch:62954/kat/nixfiles.git main
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
