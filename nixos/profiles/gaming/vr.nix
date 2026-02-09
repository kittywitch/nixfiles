{
  pkgs,
  lib,
  inputs,
  config,
  ...
}: let
  inherit (lib.lists) singleton;
  inherit (lib.meta) getExe' getExe;
in {
  systemd.user.services.wayvr = {
    description = "wayvr";
    serviceConfig = {
      Type = "simple";
      ExecStart = getExe' pkgs.wayvr "wayvr";
    };
  };
  programs.steam.extraPackages = with pkgs.gst_all_1; [
    gstreamer
    gst-plugins-base
    gst-plugins-bad
    gst-plugins-good
    # ffmpeg to play almost every format
    gst-libav
    # hardware acceleration
    gst-vaapi
  ];
  services.wivrn = {
    enable = true;
    openFirewall = true;
    steam.importOXRRuntimes = true;
    monadoEnvironment = {
      XRT_COMPOSITOR_COMPUTE = "1";
      U_PACING_APP_USE_MIN_FRAME_PERIOD="1";
      U_PACING_APP_IMMEDIATE_WAIT_FRAME_RETURN="1";
      XRT_COMPOSITOR_FORCE_WAYLAND_DIRECT = "1";
    };
    package = pkgs.wivrn.override { cudaSupport = true; };
    highPriority = true;
    defaultRuntime = true;
  };

  systemd.user.services.wivrn.serviceConfig.ExecStart = lib.mkForce(getExe config.services.wivrn.package);

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
    wayvr
    monado-vulkan-layers
    bs-manager
    android-tools
    vrcx
    alcom
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
