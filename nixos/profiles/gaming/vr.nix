{pkgs, ...}: {
  services.wivrn = {
    enable = true;
    openFirewall = true;
    package = pkgs.wivrn.override {cudaSupport = true;};
    defaultRuntime = true;
    config = {
      enable = true;
      json = {
        scale = [0.5 0.5];
        bitrate = 300 * 1000;
        encoders = [
          {
            encoder = "nvenc";
            codec = "h265";
            width = 1.0;
            height = 1.0;
            offset_x = 0.0;
            offset_y = 0.0;
          }
        ];
        tcp_only = false;
        #application = [
        #  "${pkgs.wlx-overlay-s}/bin/wlx-overlay-s"
        #];
      };
    };
  };

  environment.systemPackages = with pkgs; [
    wlx-overlay-s
    monado-vulkan-layers
    bs-manager
  ];

  networking.firewall = {
    allowedTCPPorts = [9757];
    allowedUDPPorts = [9757];
  };
}
