{
  config,
  pkgs,
  ...
}: {
  boot.extraModulePackages = with config.boot.kernelPackages; [
    # TODO: check if working post 2025-12-04
    #v4l2loopback
  ];
  programs.obs-studio = {
    enable = true;
    #enableVirtualCamera = true;
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
