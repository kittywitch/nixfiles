{pkgs, ...}: {
  environment.systemPackages = [
    pkgs.magic-wormhole
    pkgs.ntfy-sh
  ];
}
