{ pkgs, inputs, ... }: {
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    platformOptimizations.enable = true;
    extraCompatPackages = [
        inputs.nix-proton-cachyos.packages.${pkgs.system}.proton-cachyos
    ];
  };
}
