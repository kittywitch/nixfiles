{ lib, channels, ... }:
with lib; {
  name = "niv-update";
  ci.gh-actions.enable = true;
  ci.gh-actions.export = true;

  gh-actions.env.OPENSSH_PRIVATE_KEY = "\${{ secrets.OPENSSH_PRIVATE_KEY }}";

  gh-actions = {
    on = {
      schedule = [ {
        cron = "0 0 * * *";
      } ];
    };
  };

  jobs.niv-update = {
      tasks.niv-build.inputs = with channels.cipkgs;
        ci.command {
          name = "niv-update-build";
          displayName = "niv update build";
          nativeBuildInputs = [ nix ];
          environment = [ "OPENSSH_PRIVATE_KEY" ];
          command = ''
            mkdir ~/.ssh
            echo "$OPENSSH_PRIVATE_KEY" > ~/.ssh/id_rsa
            chmod 0600 ~/.ssh/id_rsa
            GIT_SSH_COMMAND="ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no" git clone ssh://gitea@git.kittywit.ch:62954/kat/nixfiles.git
            rmdir nixfiles/trusted
            ln -s $PWD nixfiles/trusted
            cd nixfiles
            nix run -f . pkgs.niv  -c niv update
            if git status --porcelain | grep -qF nix/sources.json ; then
              if nix build -Lf . hosts.{athame,yule,samhain}.config.system.build.toplevel; then
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
