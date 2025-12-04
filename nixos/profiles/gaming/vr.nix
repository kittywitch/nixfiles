{
  pkgs,
  lib,
  ...
}: let
  inherit (lib.lists) singleton;
  inherit (lib.meta) getExe';
in {
  systemd.user.services.wlx-overlay-s = {
    description = "wlx-overlay-s";
    serviceConfig = {
      Type = "simple";
      ExecStart = getExe' pkgs.wlx-overlay-s "wlx-overlay-s";
    };
  };
  services.wivrn = {
    enable = true;
    openFirewall = true;
    steam.importOXRRuntimes = true;
    monadoEnvironment = {
      XRT_COMPOSITOR_COMPUTE = "1";
    };
    package = pkgs.wivrn.overrideAttrs (_old: rec {
      cudaSupport = true;
      #version = "84e5203be3019278925ac03708567f2982360f8a";
      #src = pkgs.fetchFromGitHub {
      #  owner = "notpeelz";
      #  repo = "WiVRn";
      #  rev = version;
      #  # This will throw an error when evaluating and give you the correct hash - put that here
      #  hash = "sha256-2s3j6vRtIRf6x+lQPobcuT1vzlCh1lMA54EUiCnxoFI=";
      #};
      #cmakeFlags =
      #  old.cmakeFlags
      #  ++ [
      #    (lib.cmakeBool "WIVRN_FEATURE_SOLARXR" true)
      #  ];
    });
    defaultRuntime = true;
    config = {
      enable = true;
      json = {
        scale = [0.5 0.5];
        bit-depth = 10;
        bitrate = 50000 * 1000;
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

  # SlimeVR ports
  networking.firewall = let
    slimevr = {
      tcp = [6969 8266 35903];
      udp = [21110];
    };
    wivrn = let
      single = singleton 9757;
    in {
      tcp = single;
      udp = single;
    };
  in {
    allowedUDPPorts = slimevr.udp ++ wivrn.udp;
    allowedTCPPorts = slimevr.tcp ++ wivrn.tcp;
  };

  environment.systemPackages = with pkgs; [
    wlx-overlay-s
    monado-vulkan-layers
    bs-manager
    vrcx
    appimage-run
    (unityhub.override {
      extraLibs = unityhubPkgs: [
        (unityhubPkgs.runCommand "libxml2-fake-old-abi" {} ''
          mkdir -p "$out/lib"
          ln -s "${unityhubPkgs.lib.getLib unityhubPkgs.libxml2}/lib/libxml2.so" "$out/lib/libxml2.so.2"
        '')
      ];
    })
    #slimevr
    #slimevr-server
    #inputs.slimevr-wrangler.packages.${pkgs.system}.slimevr-wrangler
  ];
}
