{ sources, ... }:

{
  imports = [ (sources.tf-nix + "/modules/home/secrets.nix") ];
}
