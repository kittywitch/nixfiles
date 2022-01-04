{ config, pkgs, lib, ... }: with lib; let
  screenstubConfig = let
    jsonConfig = builtins.toJSON {
    exit_events = [ "show_host" ];
    hotkeys = [
      {
        events = [
          { toggle_grab = { x = { mouse = false; }; }; }
          {
            toggle_grab = {
              evdev = {
                devices = [
                  "/dev/input/by-id/usb-Razer_Razer_Naga_Trinity_00000000001A-event-mouse"
                ];
                evdev_ignore = [ "button" ];
                exclusive = false;
                xcore_ignore = [ "absolute" ];
              };
            };
          }
          "unstick_host"
        ];
        modifiers = [ "LeftMeta" ];
        triggers = [ "Esc" ];
      }
      {
        events = [ "toggle_show" ];
        modifiers = [ "LeftMeta" ];
        on_release = false;
        triggers = [ "T" ];
      }
    ];
    key_remap = {
      LeftMeta = "Reserved";
      RightAlt = "LeftMeta";
    };
    qemu = {
      absolute_driver = { virtio = { bus = "pci.21"; }; };
      ga_socket = "/tmp/vfio-qga";
      keyboard_driver = { virtio = { bus = "pci.23"; }; };
      qmp_socket = "/tmp/vfio-qmp";
      relative_driver = { virtio = { bus = "pci.22"; }; };
      routing = "virtio-host";
    };
    screens = [{
      ddc = {
        guest = [ "ddc" ];
        host = [ "ddc" ];
      };
      guest_source = { name = "HDMI-1"; };
      host_source = { name = "HDMI-2"; };
      monitor = {
        manufacturer = "BNQ";
        model = "BenQ GW2270";
      };
    }];
  }; in pkgs.writeText "screenstub.json" jsonConfig;
  win10-screenstub = pkgs.writeShellScriptBin "win10-screenstub" ''
    ${pkgs.screenstub}/bin/screenstub -c "${screenstubConfig}" x
  '';
  win10-diskmapper = pkgs.writeShellScriptBin "win10-diskmapper" ''
    sudo ${pkgs.disk-mapper}/bin/disk-mapper /dev/disk/by-id/ata-ST2000DM008-2FR102_WK301C3H-part2
  '';
in
{
  options.home-manager.users = let
      userVFIOExtend = { config, ... }: {
        config = mkIf config.wayland.windowManager.sway.enable {
          wayland.windowManager.sway.config.input = mapListToAttrs  (t:
            nameValuePair "5824:1503:screenstub-${t}" ({ events = "disabled"; })
          ) [ "tablet" "mouse" "kbd" ];
        };
      };
    in mkOption {
    type = types.attrsOf (types.submoduleWith {
      modules = singleton userVFIOExtend;
    });
  };

  config = {
    deploy.profile.vfio = true;

    environment.systemPackages = with pkgs; [
      win10-screenstub
      win10-vm
      win10-diskmapper
      ddcutil
    ];

    users.groups = { uinput = { }; vfio = { }; };

    boot = lib.mkMerge [{
      initrd.kernelModules = mkBefore [ "vfio" "vfio_iommu_type1" "vfio_pci" "vfio_virqfd" ];
      kernelModules = [ "i2c-dev" ]; # i2c-dev is required for DDC/CI for screenstub
      kernelPatches = with pkgs.kernelPatches; [
        (mkIf config.deploy.profile.hardware.acs-override acs-override)
      ];
    }
      (mkIf (config.deploy.profile.hardware.amdgpu) {
        kernelParams = [
          "video=efifb:off"
        ];
        extraModulePackages = [
          (pkgs.linuxPackagesFor config.boot.kernelPackages.kernel).vendor-reset
        ];
      })
      (mkIf (config.deploy.profile.hardware.acs-override) {
        kernelParams = [
          "pci=noats"
          "pcie_acs_override=downstream,multifunction"
        ];
      })];

    environment.etc."qemu/bridge.conf".text = "allow br";

    security.wrappers = {
      qemu-bridge-helper = {
        source = "${pkgs.qemu-vfio}/libexec/qemu-bridge-helper";
        capabilities = "cap_net_admin+ep";
        owner = "root";
        group = "root";
      };
    };

    services.udev.extraRules = ''
      SUBSYSTEM=="i2c-dev", GROUP="vfio", MODE="0660"
      SUBSYSTEM=="misc", KERNEL=="uinput", OPTIONS+="static_node=uinput", MODE="0660", GROUP="uinput"
      SUBSYSTEM=="vfio", OWNER="root", GROUP="vfio"
    '';

    security.pam.loginLimits = [{
      domain = "@vfio";
      type = "-";
      item = "memlock";
      value = "unlimited";
    }];

    systemd.extraConfig = "DefaultLimitMEMLOCK=infinity";
  };
}
