{
  pkgs,
  inputs,
  ...
}: {
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    platformOptimizations.enable = true;
    extraCompatPackages = [
      inputs.chaotic.packages.${pkgs.system}.proton-cachyos_x86_64_v3
      inputs.chaotic.packages.${pkgs.system}.proton-ge-custom
    ];
  };
}
