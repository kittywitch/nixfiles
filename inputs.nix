let
  lock = builtins.fromJSON (builtins.readFile ./flake.lock);
  lockTrusted = builtins.fromJSON (builtins.readFile ./trusted/flake.lock);
  flakeCompat = fetchTarball {
    url = "https://github.com/edolstra/flake-compat/archive/${lock.nodes.flake-compat.locked.rev}.tar.gz";
    sha256 = lock.nodes.flake-compat.locked.narHash;
  };
  nixfiles = import flakeCompat {
    src = ./.;
  };
  trusted = import flakeCompat {
    src = ./trusted;
  };
in nixfiles.defaultNix.inputs // (if builtins.getEnv "TRUSTED" != "" then {
  inherit (trusted.defaultNix.inputs) trusted;
} else {})
