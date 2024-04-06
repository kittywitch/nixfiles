{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    rtl-sdr
    sdrpp
    sdrangel
  ];
  hardware.rtl-sdr.enable = true;
  users.users.kat.extraGroups = ["plugdev"];
}
