let
  lock = builtins.fromJSON (builtins.readFile ./flake.lock);
  lockTrusted = builtins.fromJSON (builtins.readFile ./trusted/flake.lock);
  flakeCompat = fetchTarball {
    url = "https://github.com/edolstra/flake-compat/archive/${lock.nodes.flake-compat.locked.rev}.tar.gz";
    sha256 = lock.nodes.flake-compat.locked.narHash;
  };
  trusted = import flakeCompat {
    src = ./trusted;
  };
  nixfiles = import flakeCompat {
    src = ./.;
  };
in nixfiles.defaultNix.inputs // {
  trusted = if builtins.getEnv "TRUSTED" != ""
    then trusted.defaultNix.inputs.trusted
    else ./empty;
}
