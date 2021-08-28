{ sources, ... }:

{
  disabledModules = [ "programs/vim.nix" ];
  imports = [
    (import (sources.arcexprs + "/modules")).home-manager
    (import (sources.katexprs + "/modules")).home
    (import (sources.impermanence + "/home-manager.nix"))
    ./vim.nix
    ./fvwm.nix
    ./deploy.nix
    ./theme.nix
    ./secrets.nix
    (sources.tf-nix + "/modules/home/secrets.nix")
  ];
}
