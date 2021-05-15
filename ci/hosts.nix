{ lib, channels, env, ... }: with lib; let
  nixfiles = import ./.; 
in {
  name = "hosts";
  ci.gh-actions.enable = true;
  ci.gh-actions.export = true;

  jobs = let hostnames = [ "samhain" "yule" "athame" ];
  in mapAttrs' (k: nameValuePair "host-${k}") (genAttrs hostnames (host: {
      tasks.${host}.inputs = nixfiles.hosts.${host}.config.system.build.toplevel;
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
