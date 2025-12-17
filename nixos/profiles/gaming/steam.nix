{
  pkgs,
  inputs,
  ...
}: {
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    extraCompatPackages = [
      pkgs.proton-cachyos-x86_64_v3
      pkgs.proton-ge-bin
    ];
  };
}
