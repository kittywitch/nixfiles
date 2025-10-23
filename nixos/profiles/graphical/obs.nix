{
  config,
  pkgs,
  ...
}: {
  boot.extraModulePackages = with config.boot.kernelPackages; [
    v4l2loopback
  ];
  programs.obs-studio = {
    enable = true;
    enableVirtualCamera = true;
    plugins = with pkgs.obs-studio-plugins; [
      #obs-vaapi
      #obs-tuna
      #obs-source-clone
      obs-pipewire-audio-capture
      #input-overlay
      obs-vkcapture
    ];
  };
}
