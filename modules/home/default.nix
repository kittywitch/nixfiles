{ sources, ... }:

{
  disabledModules = [ "programs/vim.nix" ];
  imports = with (import (sources.arc-nixexprs + "/modules")).home-manager; [ base16 syncplay konawall i3gopher weechat shell ] ++ [
    ./vim.nix
    ./deploy-tf
    (sources.tf-nix + "/modules/home/secrets.nix")
  ];
}
