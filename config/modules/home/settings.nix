{ sources, ... }: {
  functor = {
    enable = true;
    external = [
      (import (sources.arcexprs + "/modules")).home-manager
      (import (sources.katexprs + "/modules")).home
      (import (sources.impermanence + "/home-manager.nix"))
      (import sources.anicca).modules.home
      (sources.tf-nix + "/modules/home/secrets.nix")
    ];
  };
}
