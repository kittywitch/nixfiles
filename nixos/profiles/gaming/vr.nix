{
  pkgs,
  lib,
  ...
}: {
  services.wivrn = {
    enable = true;
    openFirewall = true;
    package = pkgs.wivrn.overrideAttrs (old: rec {
      cudaSupport = true;
      version = "84e5203be3019278925ac03708567f2982360f8a";
      src = pkgs.fetchFromGitHub {
        owner = "notpeelz";
        repo = "WiVRn";
        rev = version;
        # This will throw an error when evaluating and give you the correct hash - put that here
        hash = "sha256-2s3j6vRtIRf6x+lQPobcuT1vzlCh1lMA54EUiCnxoFI=";
      };
      cmakeFlags =
        old.cmakeFlags
        ++ [
          (lib.cmakeBool "WIVRN_FEATURE_SOLARXR" true)
        ];
    });
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
