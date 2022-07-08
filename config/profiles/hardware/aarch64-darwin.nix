{ config, lib, ... }: with lib; {
  nixpkgs.system = "aarch64-darwin";
}
