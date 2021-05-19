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

  jobs.niv-update = {
      tasks.niv-build.inputs = with channels.cipkgs;
        ci.command {
          name = "niv-update-build";
          displayName = "niv update build";
          nativeBuildInputs = [ nix cachix ];
          environment = [ "OPENSSH_PRIVATE_KEY" "CACHIX_SIGNING_KEY" ];
          command = let sources = (import ../.).sources; in
          ''
            mkdir ~/.ssh
            echo "$OPENSSH_PRIVATE_KEY" > ~/.ssh/id_rsa
            chmod 0600 ~/.ssh/id_rsa
            for source in ${toString (attrNames sources)}; do
              nix run -f . pkgs.niv  -c niv update $source || true
            done
            if git status --porcelain | grep -qF nix/sources.json; then
              if nix build -Lf . hosts.{athame,yule,samhain}.config.system.build.toplevel; then
                nix build -f ../. sourceCache
                ${cachix}/bin/cachix push kittywitch $(nix eval '(toString (import ../.).sourceCache)')
                nix-build $(echo "-A hosts."{athame,yule,samhain}.config.system.build.toplevel) | ${cachix}/bin/cachix push kittywitch
                git add nix/sources.json
                export GIT_{COMMITTER,AUTHOR}_EMAIL=kat@kittywit.ch
                export GIT_{COMMITTER,AUTHOR}_NAME=kat witch
                git commit --message="ci-trusted: niv update"
                GIT_SSH_COMMAND="ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no" git push
              fi
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
