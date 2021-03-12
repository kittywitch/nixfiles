{ sources, ... }:

{
  disabledModules = [
    "programs/vim.nix"
  ];
  imports = [
    ./vim.nix
    (sources.tf-nix + "/modules/home/secrets.nix")
    (sources.arc-nixexprs + "/modules/home/weechat.nix")
  ];
}
