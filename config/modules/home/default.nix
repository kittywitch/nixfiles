{ sources, ... }:

{
  disabledModules = [ "programs/vim.nix" ];
  imports = with (import (sources.nixexprs + "/modules")).home-manager; [ base16 syncplay konawall i3gopher weechat shell ] ++ [
    ./vim.nix
    ./deploy-tf.nix
    (sources.tf-nix + "/modules/home/secrets.nix")
  ];
}
