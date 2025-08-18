{
  lib,
  channels,
  config,
  ...
}:
with lib; {
  imports = [./common.nix];
  config = {
    name = "flake-update";

    gh-actions = {
      env = {
        CACHIX_AUTH_TOKEN = "\${{ secrets.CACHIX_AUTH_TOKEN }}";
        CACHIX_SIGNING_KEY = "\${{ secrets.CACHIX_SIGNING_KEY }}";
        DISCORD_WEBHOOK_LINK = "\${{ secrets.DISCORD_WEBHOOK_LINK }}";
      };
      on = let
        paths = [
          "default.nix" # sourceCache
          "ci/flake-cron.nix"
          config.ci.gh-actions.path
        ];
      in {
        push = {
          inherit paths;
        };
        pull_request = {
          inherit paths;
        };
        schedule = [
          {
            cron = "0 0 * * *";
          }
        ];
        workflow_dispatch = {};
      };
      jobs.flake-update = {
        step.flake-update = {
          name = "flake update build";
          order = 500;
          run = "${channels.nixpkgs.lix}/bin/nix run .#nf-update";
          env = {
            CACHIX_AUTH_TOKEN = "\${{ secrets.CACHIX_AUTH_TOKEN }}";
            CACHIX_SIGNING_KEY = "\${{ secrets.CACHIX_SIGNING_KEY }}";
            DISCORD_WEBHOOK_LINK = "\${{ secrets.DISCORD_WEBHOOK_LINK }}";
            NF_UPDATE_GIT_COMMIT = "1";
            NF_UPDATE_CACHIX_PUSH = "1";
            NF_CONFIG_ROOT = "\${{ github.workspace }}";
          };
        };
      };
    };

    jobs = {
      flake-update = {...}: {
        imports = [./packages.nix];
      };
    };

    ci.gh-actions.checkoutOptions = {
      fetch-depth = 0;
    };
  };
}
