{ sources, ... }: {
  external = [
    (import (sources.arcexprs + "/modules")).nixos
    (import (sources.katexprs + "/modules")).nixos
    (import (sources.impermanence + "/nixos.nix"))
    (import sources.anicca).modules.nixos
    (sources.tf-nix + "/modules/nixos/secrets.nix")
    (sources.tf-nix + "/modules/nixos/secrets-users.nix")
  ];
}
