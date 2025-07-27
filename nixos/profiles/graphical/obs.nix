{ pkgs, ... }: {
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
