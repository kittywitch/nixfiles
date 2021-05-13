{ lib, channels, ... }: with lib; {
  name = "nixfiles";
  ci.gh-actions.enable = true;
  ci.gh-actions.export = true;

  tasks = let hostnames = [ "samhain" "yule" "athame" ];
  in mapAttrs' (k: nameValuePair "host-${k}") (genAttrs hostnames (host: {
      inputs = with channels.cipkgs; ci.command {
        name = "build-${host}";
        displayName = "build hosts/${host}";
        nativeBuildInputs = [ nix ];
        command = ''
          nix build -Lf . hosts.${host}.config.system.build.toplevel --show-trace --no-link
          nix-collect-garbage
        '';
        impure = true;
      };
    }));

  ci.gh-actions.checkoutOptions.submodules = false;
  cache.cachix.arc = {
    enable = true;
    publicKey = "arc.cachix.org-1:DZmhclLkB6UO0rc0rBzNpwFbbaeLfyn+fYccuAy7YVY=";
  };
  cache.cachix.kittywitch = {
    enable = true;
    publicKey = "kittywitch.cachix.org-1:KIzX/G5cuPw5WgrXad6UnrRZ8UDr7jhXzRTK/lmqyK0=";
  };
}
