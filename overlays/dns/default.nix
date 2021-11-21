{ inputs, ... }: final: prev: {
  dns = import inputs.nix-dns;
}
