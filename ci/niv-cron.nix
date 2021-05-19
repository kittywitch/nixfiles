{ lib, channels, ... }:
with lib; {
  name = "niv-update";
  ci.gh-actions.enable = true;
  ci.gh-actions.export = true;

  gh-actions.env.OPENSSH_PRIVATE_KEY = "\${{ secrets.OPENSSH_PRIVATE_KEY }}";
  gh-actions.env.CACHIX_SIGNING_KEY = "\${{ secrets.CACHIX_SIGNING_KEY }}";

  gh-actions = {
    on = let
      paths = [ "nix/*" "ci/*" ];
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
            mkdir ~/.ssh
            echo "$OPENSSH_PRIVATE_KEY" > ~/.ssh/id_rsa
            chmod 0600 ~/.ssh/id_rsa

            for source in ${toString (attrNames channels.nixfiles.sources)}; do
              niv update $source || true
            done

            if git status --porcelain | grep -qF nix/sources.json; then
              if nix build -Lf . hosts.{athame,yule,samhain}.config.system.build.toplevel; then
                nix build -f ../. sourceCache
                cachix push kittywitch $(nix eval '(toString (import ../.).sourceCache)')
                nix-build $(echo "-A hosts."{athame,yule,samhain}.config.system.build.toplevel) | cachix push kittywitch
                git add nix/sources.json
                export GIT_{COMMITTER,AUTHOR}_EMAIL=kat@kittywit.ch
                export GIT_{COMMITTER,AUTHOR}_NAME=kat witch
                git commit --message="ci-trusted: niv update"
                git remote add gitea ssh://gitea@git.kittywit.ch:62954/kat/nixfiles.git
                GIT_SSH_COMMAND="ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no" \
                  git push gitea master
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
