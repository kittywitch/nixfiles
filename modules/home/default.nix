{ sources, ... }:

{
  disabledModules = [ "programs/vim.nix" ];
  imports = [
    ./vim.nix
    (sources.tf-nix + "/modules/home/secrets.nix")
    (import (sources.arc-nixexprs + "/modules")).home-manager.base16
    (import (sources.arc-nixexprs + "/modules")).home-manager.syncplay
    #    (sources.arc-nixexprs + "/modules/home/base16-shell.nix")
    (sources.arc-nixexprs + "/modules/home/weechat.nix")
  ];
}
