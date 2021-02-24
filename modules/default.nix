{ ... }:

let sources = import ../nix/sources.nix;
in { imports = [ ./deploy ]; }
