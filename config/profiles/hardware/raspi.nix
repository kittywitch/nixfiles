{ config, ... }: {
  deploy.profil.hardware.raspi = true;

  nixpkgs.crossOverlays = [
    (import ../../../overlays/pi)
  ];

  boot = {
    loader = {
      grub.enable = false;
      generic-extlinux-compatible.enable = true;
    };
    consoleLogLevel = lib.mkDefault 7;
    kernelPackages = pkgs.linuxPackages_rpi1;
    kernelModules = mkForce [ "loop" "atkbd" ];
    initrd = {
      includeDefaultModules = false;
      availableKernelModules = mkForce [
        "mmc_block"
        "usbhid"
        "ext4"
        "hid_generic"
        "hid_lenovo"
        "hid_apple"
        "hid_roccat"
        "hid_logitech_hidpp"
        "hid_logitech_dj"
        "hid_microsoft"
      ];
    };
  };

  environment.noXlibs = true;
  documentation.info.enable = false;
  documentation.man.enable = false;
  programs.command-not-found.enable = false;
  security.polkit.enable = false;
  security.audit.enable = false;
  services.udisks2.enable = false;
  boot.enableContainers = false;

  nixpkgs.crossSystem = systems.examples.raspberryPi // {
    system = "armv6l-linux";
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
    };
  };
}
