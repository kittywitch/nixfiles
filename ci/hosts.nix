{ lib, channels, env, ... }: with lib; {
  name = "hosts";
  ci.gh-actions.enable = true;
  ci.gh-actions.export = true;
  channels.nixfiles.path = ../.;

  # ensure sources are fetched and available in the local store before evaluating host configs
  environment.bootstrap = {
    sourceCache = channels.cipkgs.runCommand "sources" {
      srcs = attrNames channels.nixfiles.sourceCache.local;
    } ''
      mkdir -p $out/share/sources
      ln -s $srcs $out/share/sources/
    '';
  };

  jobs = let hostnames = remove "dummy" (lib.attrNames (import ../.).hosts);
  in mapAttrs' (k: nameValuePair "host-${k}") (genAttrs hostnames (host: {
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
