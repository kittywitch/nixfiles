{ lib, ... }: with lib; {
  name = "nixfiles";
  ci.gh-actions.enable = true;
  ci.gh-actions.export = true;
  gh-actions.jobs.ci.step = let 
    hostnames = [ "samhain" "yule" "athame"];
  in mapAttrs' (k: nameValuePair "host-${k}") (genAttrs hostnames (host: {
    name = "build host/${host}";
    run = "nix build -Lf . hosts.${host}.config.system.build.toplevel --show-trace";
  }));
  ci.gh-actions.checkoutOptions.submodules = false;
  cache.cachix.kittywitch = {
    enable = true;
    publicKey = "kittywitch.cachix.org-1:KIzX/G5cuPw5WgrXad6UnrRZ8UDr7jhXzRTK/lmqyK0=";
  };
}
