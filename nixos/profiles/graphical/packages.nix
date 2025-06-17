{
  pkgs,
  inputs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    jmtpfs
    dnsutils
    usbutils
    plexamp
    super-slicer-beta
    nvidia-vaapi-driver
    nv-codec-headers-12
    inputs.push2talk.defaultPackage.${pkgs.system}
  ];
  programs.obs-studio = {
    enable = true;
    enableVirtualCamera = true;
    package = pkgs.obs-studio.override {
      cudaSupport = true;
    };
    plugins = with pkgs.obs-studio-plugins; [
      obs-vaapi
      obs-tuna
      obs-source-clone
      obs-pipewire-audio-capture
      input-overlay
      obs-vkcapture
    ];
  };
  services.udev.packages = [
    pkgs.android-udev-rules
    pkgs.zsa-udev-rules
    pkgs.via
  ];
}
