{ config, pkgs, lib, ... }: with lib; let
  win10-toggler = pkgs.writeShellScriptBin "win10-toggle" ''
REQUEST="$0"
if [[ "REQUEST" = "on" ]]; then
  sudo win10-vm-pinning $(cat $XDG_RUNTIME_DIR/win10-vm.pid)
  systemctl --user stop konawall-rotation.timer
else
  sudo win10-vm-pinning
	systemctl --user start konawall-rotation.timer
fi
  '';
  win10-start-pane = pkgs.writeShellScriptBin "win10-start-pane" ''
sudo disk-mapper-part /dev/disk/by-id/ata-ST2000DM008-2FR102_WK301C3H-part2
sudo chown kat:users /dev/mapper/ata-ST2000DM008-2FR102_WK301C3H-part2
echo 3 | sudo tee /proc/sys/vm/drop_caches > /dev/null || true; echo 1 | sudo tee /proc/sys/vm/compact_memory > /dev/null || true
win10-vm -pidfile $XDG_RUNTIME_DIR/win10-vm.pid
  '';
  win10-start = pkgs.writeShellScriptBin "win10-start" ''
tmux new-session -ds vm "${win10-start-pane}/bin/win10-start-pane" \; split-window -h 'sleep 10; screenstub x'
  '';
in {
  options.home-manager.users = let
      userVFIOExtend = { config, ... }: {
        config = mkMerge [
          (mkIf config.wayland.windowManager.sway.enable {
          wayland.windowManager.sway.config.input = mapListToAttrs  (t:
            nameValuePair "5824:1503:screenstub-${t}" ({ events = "disabled"; })
          ) [ "tablet" "mouse" "kbd" ];
        })
        {
          programs.screenstub = {
            enable = true;
            settings = {
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
            };
          };
        }
        ];
      };
    in mkOption {
    type = types.attrsOf (types.submoduleWith {
      modules = singleton userVFIOExtend;
    });
  };

  config = {
    deploy.profile.vfio = true;

    environment.systemPackages = with pkgs; [
      win10-toggler
      vfio-vm
      vfio-vm-pinning
      vfio-disk-mapper
      win10-start
      ddcutil
    ];

    systemd.mounts = let
      hugepages = { where, options }: {
        before = ["sysinit.target"];
        unitConfig = {
          DefaultDependencies = "no";
          ConditionPathExists = "/sys/kernel/mm/hugepages";
          ConditionCapability = "CAP_SYS_ADMIN";
          ConditionVirtualization = "!private-users";
        };
        what = "hugetlbfs";
        inherit where options;
        type = "hugetlbfs";
        mountConfig = {
          Group = "vfio";
        };
        wantedBy = ["sysinit.target"];
      };
    in [
      (hugepages { where = "/dev/hugepages"; options = "mode=0775"; })
      (hugepages { where = "/dev/hugepages1G"; options = "pagesize=1GB,mode=0775"; })
    ];

  /*  fileSystems."/sys/fs/cgroup/cpuset" = {
      device = "cpuset";
      fsType = "cgroup";
      noCheck = true;
    }; */

    systemd.services.preallocate-huggies = {
      wantedBy = singleton "multi-user.target";
      serviceConfig = {
        Type = "oneshot";
      };
      script = ''
        echo 12 > /sys/kernel/mm/hugepages/hugepages-1048576kB/nr_hugepages
      '';
    };

    users.groups = { uinput = { }; vfio = { }; };

    boot = lib.mkMerge [{
      initrd.kernelModules = mkBefore [ "vfio" "vfio_iommu_type1" "vfio_pci" "vfio_virqfd" ];
      kernelParams = [
      ];
      kernelModules = [ "i2c-dev" ]; # i2c-dev is required for DDC/CI for screenstub
      kernelPatches = with pkgs.kernelPatches; [
        (mkIf config.deploy.profile.hardware.acs-override acs-override)
        {
          name = "clocksource-reduce-tsc-tolerance";
          patch = ./tsc-tolerance.patch;
        }
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
