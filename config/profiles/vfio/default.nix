{ config, pkgs, lib, ... }:

with lib;

{
  deploy.profile.vfio = true;

  environment.systemPackages = with pkgs; [
    screenstub
    kat-vm
    ddcutil
  ];


  users.users.kat.extraGroups = [ "vfio" "input" "uinput" ];
  users.groups = { uinput = { }; vfio = { }; };

  boot = lib.mkMerge [ {
    initrd.kernelModules = mkBefore ["vfio" "vfio_iommu_type1" "vfio_pci" "vfio_virqfd"];
    kernelModules = [ "i2c-dev" ]; # i2c-dev is required for DDC/CI for screenstub
    kernelPatches = with pkgs.kernelPatches; [
      (mkIf config.deploy.profile.hardware.acs-override acs-override)
    ];
  } (mkIf (config.deploy.profile.hardware.amdgpu) {
    kernelParams = [
      "video=efifb:off"
    ];
    extraModulePackages = [
    (pkgs.linuxPackagesFor config.boot.kernelPackages.kernel).vendor-reset
    ];
  }) ( mkIf (config.deploy.profile.hardware.acs-override) {
    kernelParams = [
      "pci=noats"
      "pcie_acs_override=downstream,multifunction"
    ];
  }) ];

  environment.etc."qemu/bridge.conf".text = "allow br";

  security.wrappers = {
    qemu-bridge-helper = {
      source = "${pkgs.qemu-vfio}/libexec/qemu-bridge-helper";
    };
  };

  services.udev.extraRules = ''
    SUBSYSTEM=="i2c-dev", GROUP="vfio", MODE="0660"
    SUBSYSTEM=="misc", KERNEL=="uinput", OPTIONS+="static_node=uinput", MODE="0660", GROUP="uinput"
    SUBSYSTEM=="vfio", OWNER="root", GROUP="vfio"
  '';

  security.pam.loginLimits = [{
    domain = "@vfio";
    type = "-";
    item = "memlock";
    value = "unlimited";
  }];

  systemd.extraConfig = "DefaultLimitMEMLOCK=infinity";
}
