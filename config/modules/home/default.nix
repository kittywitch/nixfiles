{ sources, ... }:

{
  imports = [
    (import (sources.arcexprs + "/modules")).home-manager
    (import (sources.katexprs + "/modules")).home
    (import (sources.impermanence + "/home-manager.nix"))
    (import sources.anicca).modules.home
    ./deploy.nix
    ./theme.nix
    ./secrets.nix
    (sources.tf-nix + "/modules/home/secrets.nix")
  ];
}
