{
  meta,
  config,
  lib,
  utils,
  pkgs,
  modulesPath,
  ...
}: let
  hddopts = ["luks" "discard" "noauto" "nofail"];
  md = {
    shadow = rec {
      name = "shadowlegend";
      device = "/dev/md/${name}";
      unit = utils.escapeSystemdPath device;
      service = "md-shadow.service";
      cryptDisks =
        lib.flip lib.mapAttrs {
          seagate0 = {
            device = "/dev/disk/by-uuid/78880135-6455-4603-ae07-4e044a77b740";
            keyFile = "/root/ST4000DM000-1F21.key";
            options = hddopts;
          };
          hgst = {
            device = "/dev/disk/by-uuid/4033c877-fa1f-4f75-b9de-07be84f83afa";
            keyFile = "/root/HGST-HDN724040AL.key";
            options = hddopts;
          };
        } (disk: attrs:
          attrs
          // {
            service = "systemd-cryptsetup@${disk}.service";
          });
    };
  };
in {
  imports = with meta;
    [
      (modulesPath + "/installer/scan/not-detected.nix")
      nixos.sops
      inputs.systemd2mqtt.nixosModules.default
      ./access.nix
      ./syncplay.nix
      ./kanidm.nix
      ./vouch.nix
      ./home-assistant.nix
      ./zigbee2mqtt.nix
      ./mosquitto.nix
      ./postgres.nix
      ./nginx.nix
      ./mediatomb.nix
      ./deluge.nix
      ./cloudflared.nix
    ];

  boot.supportedFilesystems = ["nfs"];

  services.udev.extraRules = ''
    SUBSYSTEM=="tty", GROUP="input", MODE="0660"
  '';

  services.cockroachdb.locality = "provider=local,network=gensokyo,host=${config.networking.hostName}";

  sops.defaultSopsFile = ./secrets.yaml;

  networking = {
    useDHCP = false;
    interfaces = {
      eno1 = {
        useDHCP = true;
      };
    };
  };

  environment.systemPackages = [
    pkgs.cryptsetup
    pkgs.buildPackages.rxvt-unicode-unwrapped.terminfo
  ];

  boot = {
    loader = {
      systemd-boot = {
        enable = true;
      };
      efi = {
        canTouchEfiVariables = true;
      };
    };
    initrd = {
      availableKernelModules = ["xhci_pci" "ehci_pci" "ahci" "usbhid" "usb_storage" "sd_mod"];
    };
    kernelModules = ["kvm-intel"];
  };

  services.openiscsi = {
    enable = true;
    name = "";
  };

  services.systemd2mqtt = {
    enable = true;
    user = "root";
    mqtt = {
      url = "tcp://localhost:1883";
      username = "systemd";
    };
    units = {
      "mnt-shadow.mount" = {};
      "mediatomb.service" = lib.mkIf config.services.mediatomb.enable {};
    };
  };

  environment.etc = {
    "iscsi/initiatorname.iscsi" = lib.mkForce {
      source = config.sops.secrets.openscsi-config.path;
    };
    crypttab.text = let
      inherit (lib) concatStringsSep mapAttrsToList;
      cryptOpts = lib.concatStringsSep ",";
    in
      concatStringsSep "\n" (mapAttrsToList (
          disk: {
            device,
            keyFile,
            options,
            ...
          }: "${disk} ${device} ${keyFile} ${cryptOpts options}"
        )
        md.shadow.cryptDisks);
  };

  sops.secrets = {
    openscsi-config = {};
    openscsi-env = lib.mkIf config.services.openiscsi.enableAutoLoginOut { };
    systemd2mqtt-env = {};
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/6c5d82b1-5d11-4c72-96c6-5f90e6ce57f5";
      fsType = "ext4";
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/85DC-72FA";
      fsType = "vfat";
    };
    "/mnt/shadow" = {
      device = "/dev/disk/by-uuid/84aafe0e-132a-4ee5-8c5c-c4a396b999bf";
      fsType = "xfs";
      options = [
        "x-systemd.automount"
        "noauto"
        "x-systemd.requires=${md.shadow.service}"
        "x-systemd.after=${md.shadow.service}"
        "x-systemd.after=${md.shadow.unit}"
      ];
    };
  };
  systemd = let
    inherit (lib) getExe mapAttrsToList mapAttrs' nameValuePair;
    serviceName = lib.removeSuffix ".service";
    cryptServices = mapAttrsToList (_: {service, ...}: service) md.shadow.cryptDisks;
  in {
    services = {
      nfs-mountd = {
        wants = ["network-online.target"];
      };
      mdmonitor.enable = false;
      ${serviceName md.shadow.service} = rec {
        restartIfChanged = false;
        wants = cryptServices;
        after = wants;
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = "true";
          ExecStartPre = [
            "-${getExe pkgs.mdadm} --assemble --scan"
          ];
          ExecStart = [
            "${getExe pkgs.mdadm} --detail ${md.shadow.device}"
          ];
          ExecStop = [
            "${getExe pkgs.mdadm} --stop ${md.shadow.device}"
          ];
        };
      };
      iscsid = rec {
        wantedBy = cryptServices;
        before = wantedBy;
      };
      iscsi = let
        cfg = config.services.openiscsi;
      in lib.mkIf cfg.enableAutoLoginOut {
        serviceConfig = {
          EnvironmentFile = [ config.sops.secrets.openscsi-env.path ];
          ExecStartPre = [
            "${cfg.package}/bin/iscsiadm --mode discoverydb --type sendtargets --portal $DISCOVER_PORTAL --discover"
          ];
        };
      };
      systemd2mqtt = lib.mkIf config.services.systemd2mqtt.enable rec {
        requires = lib.mkIf config.services.mosquitto.enable ["mosquitto.service"];
        after = requires;
        serviceConfig.EnvironmentFile = [
          config.sops.secrets.systemd2mqtt-env.path
        ];
      };
    };
  };

  swapDevices = lib.singleton {
    device = "/dev/disk/by-uuid/137605d3-5e3f-47c8-8070-6783ce651932";
  };

  system.stateVersion = "21.05";
}
