_: {
  boot.loader = {
    grub = {
      devices = ["nodev"];
      efiSupport = true;
      gfxmodeEfi = "1920x1080";
    };
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot";
    };
  };
}
