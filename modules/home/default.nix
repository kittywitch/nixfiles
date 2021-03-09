{ sources, ... }:

{
  imports = [
    (sources.tf-nix + "/modules/home/secrets.nix")
    (sources.arc-nixexprs + "/modules/home/weechat.nix")
  ];
}
