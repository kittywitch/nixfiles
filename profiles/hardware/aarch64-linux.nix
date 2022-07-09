{ config, lib, ... }: with lib; {
  nixpkgs.localSystem = systems.examples.aarch64-multiplatform // {
    system = "aarch64-linux";
  };
}
