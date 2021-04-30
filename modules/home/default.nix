{ sources, ... }:

{
  disabledModules = [ "programs/vim.nix" ];
  imports = [
    ./vim.nix
    (sources.tf-nix + "/modules/home/secrets.nix")
    (import (sources.arc-nixexprs + "/modules")).home-manager.base16
    (import (sources.arc-nixexprs + "/modules")).home-manager.syncplay
    (import (sources.arc-nixexprs + "/modules")).home-manager.konawall
    (sources.arc-nixexprs + "/modules/home/weechat.nix")
  ];
}
