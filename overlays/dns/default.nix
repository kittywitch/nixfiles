{ sources, ... }: final: prev: {
  dns = import sources.nix-dns;
}
