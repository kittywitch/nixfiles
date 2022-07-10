{ pkgs, config, lib, ... }: with lib; {
  boot.binfmt = {
    emulatedSystems = [ "aarch64-linux" ];
    /*
      registrations.aarch64-linux = {
      interpreter = mkForce "${pkgs.qemu-vfio or pkgs.qemu}/bin/qemu-aarch64";
      };
    */
  };
}
