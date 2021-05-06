{ sources, ... }:

{
  disabledModules = [ "programs/vim.nix" ];
  imports = [
    ./vim.nix
    ./deploy-tf
    (sources.tf-nix + "/modules/home/secrets.nix")
    (import (sources.arc-nixexprs + "/modules")).home-manager.base16
    (import (sources.arc-nixexprs + "/modules")).home-manager.syncplay
    (import (sources.arc-nixexprs + "/modules")).home-manager.konawall
    (import (sources.arc-nixexprs + "/modules")).home-manager.i3gopher
    (sources.arc-nixexprs + "/modules/home/weechat.nix")
  ];
}
