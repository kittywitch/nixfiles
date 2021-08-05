{ config, pkgs, lib, ... }:

with lib;

{
  deploy.profile.vfio = true;

  environment.systemPackages = with pkgs; [
    screenstub
    kat-vm
    ddcutil
  ];

  boot.extraModulePackages = [
    (pkgs.linuxPackagesFor config.boot.kernelPackages.kernel).vendor-reset
  ];

  users.users.kat.extraGroups = [ "vfio" "input" "uinput" ];
  users.groups = { uinput = { }; vfio = { }; };

  boot = {
    modprobe.modules = mkIf (config.deploy.profile.hardware.ms-7b86) {
      vfio-pci = let
        vfio-pci-ids = [
          "1002:67df" "1002:aaf0" # RX 580
          "1921:0014" # Renesas USB 3
          "1022:149c" # CPU USB 3
        ];
      in mkIf (vfio-pci-ids != [ ]) {
        options.ids = concatStringsSep "," vfio-pci-ids;
      };
    };
    kernelPatches = mkIf (config.deploy.profile.hardware.ms-7b86) [
      {
        name = "acs-patch.patch";
        patch = (pkgs.fetchpatch {
          name = "acs-patch.patch";
          url = "https://gitlab.com/Queuecumber/linux-acs-override/-/raw/cc30d83d05019b84468db3ad009bc02ab1bab240/workspaces/5.6.12/acso.patch?inline=false";
          sha256 = "0qjb66ydbqqypyvhhlq8zwry8zcd8609y8d4a0nidhq1g6cp9vcw";
        });
      }
    ];
    initrd.kernelModules = ["vfio" "vfio_iommu_type1" "vfio_pci" "vfio_virqfd"];
    kernelModules = [ "i2c-dev" ]; # i2c-dev is required for DDC/CI for screenstub
    kernelParams = [
      "amd_iommu=on"
      "pci=noats"
      "video=efifb:off"
      "pcie_acs_override=downstream,multifunction"
    ];
  };

  environment.etc."qemu/bridge.conf".text = "allow br";

  security.wrappers = {
    qemu-bridge-helper = {
      source = "${pkgs.qemu-vfio}/libexec/qemu-bridge-helper";
    };
  };

  services.udev.extraRules = ''
    SUBSYSTEM=="i2c-dev", GROUP="vfio", MODE="0660"
    SUBSYSTEM=="usb", ACTION=="add", ATTRS{idVendor}=="1532", ATTRS{idProduct}=="0067", GROUP="vfio"
    SUBSYSTEM=="misc", KERNEL=="uinput", OPTIONS+="static_node=uinput", MODE="0660", GROUP="uinput"
    SUBSYSTEM=="vfio", OWNER="root", GROUP="vfio"
    SUBSYSTEM=="block", ACTION=="add", ATTRS{model}=="HFS256G32TNF-N3A", ATTRS{wwid}=="t10.ATA     HFS256G32TNF-N3A0A                      MJ8BN15091150BM1Z   ", OWNER="kat"
  '';

  # TODO: Replace this drive forward with one half of the 1.82TiB drive.
  # SUBSYSTEM=="block", ACTION=="add", ATTR{partition}=="2", ATTR{size}=="1953503232", ATTRS{wwid}=="naa.5000039fe6e8614e", OWNER="kat"

  security.pam.loginLimits = [{
    domain = "@vfio";
    type = "-";
    item = "memlock";
    value = "unlimited";
  }];

  systemd.extraConfig = "DefaultLimitMEMLOCK=infinity";
  services.xserver.deviceSection = lib.mkDefault ''
    Option "TearFree" "true"
    BusID "PCI:37:0:0"
  '';
}
