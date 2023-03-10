let
  lock = builtins.fromJSON (builtins.readFile ./flake.lock);
  flakeCompat = fetchTarball {
    url = "https://github.com/edolstra/flake-compat/archive/${lock.nodes.flake-compat.locked.rev}.tar.gz";
    sha256 = lock.nodes.flake-compat.locked.narHash;
  };
  nixfiles = import flakeCompat {
    src = ./.;
  };
  trusted = import flakeCompat {
    src = if builtins.pathExists ./trusted/trusted/flake.nix
      then ./trusted/trusted
      else ./trusted;
  };
in nixfiles.defaultNix.inputs // (if builtins.getEnv "TRUSTED" != "" then {
  trusted = trusted.defaultNix;
} else {})
