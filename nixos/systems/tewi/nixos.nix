{ meta, tf, config, lib, utils, pkgs, modulesPath, ... }: let
  hddopts = [ "luks" "discard" "noauto" "nofail" ];
  md = {
    shadow = rec {
      name = "shadowlegend";
      device = "/dev/md/${name}";
      unit = utils.escapeSystemdPath device;
      service = "md-shadow.service";
      cryptDisks = lib.flip lib.mapAttrs {
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
      } (disk: attrs: attrs // {
        service = "systemd-cryptsetup@${disk}.service";
      });
    };
  };
in {
  imports = with meta; [
    (modulesPath + "/installer/scan/not-detected.nix")
    hardware.local
    nixos.arc
    nixos.sops
    ./kanidm.nix
    ./vouch.nix
    ./home-assistant.nix
    ./zigbee2mqtt.nix
    ./mosquitto.nix
    ./postgres.nix
    ./nginx.nix
    ../../gui/nfs.nix
  ] ++ lib.optional (meta.trusted ? nixos.systems.tewi.default) meta.trusted.nixos.systems.tewi.default;

  services.cockroachdb.locality = "provider=local,network=gensokyo,host=${config.networking.hostName}";

  sops.defaultSopsFile = ./secrets.yaml;

  networks = {
    gensokyo = {
      interfaces = [
        "eno1"
      ];
      ipv4 = "100.88.107.41";
    };
  };

  networking = {
    useDHCP = false;
    interfaces = {
      eno1 = {
        useDHCP = true;
      };
    };
  };

  environment.systemPackages = [ pkgs.cryptsetup ];

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
      availableKernelModules = [ "xhci_pci" "ehci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];
    };
    kernelModules = [ "kvm-intel" ];
  };

  services.mediatomb = {
    enable = true;
    openFirewall = true;
    serverName = config.networking.hostName;
    mediaDirectories = lib.singleton {
      path = "/mnt/shadow/media";
      recursive = true;
      hidden-files = false;
    };
  };

  services.openiscsi = {
    enable = true;
    name = "";
  };

  environment.etc = {
    "iscsi/initiatorname.iscsi" = lib.mkForce {
      source = config.sops.secrets.openscsi-config.path;
    };
    crypttab.text = let
      inherit (lib) concatStringsSep mapAttrsToList;
      cryptOpts = lib.concatStringsSep ",";
    in concatStringsSep "\n" (mapAttrsToList (disk: { device, keyFile, options, ... }:
      "${disk} ${device} ${keyFile} ${cryptOpts options}"
    ) md.shadow.cryptDisks);
  };

  sops.secrets.openscsi-config = { };

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
        "x-systemd.automount" "noauto"
        "x-systemd.requires=${md.shadow.service}"
        "x-systemd.after=${md.shadow.service}"
        "x-systemd.after=${md.shadow.unit}"
      ];
    };
  };
  systemd = let
    inherit (lib) getExe mapAttrsToList mapAttrs' nameValuePair;
    serviceName = lib.removeSuffix ".service";
    cryptServices = mapAttrsToList (_: { service, ... }: service) md.shadow.cryptDisks;
  in {
    services = {
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
      mediatomb = rec {
        confinement.enable = true;
        requires = [
          "mnt-shadow.mount"
        ];
        after = requires;
        serviceConfig = {
          StateDirectory = config.services.mediatomb.package.pname;
          BindReadOnlyPaths = map (path: "/mnt/shadow/media/${path}") [
            "anime" "movies" "tv" "unsorted"
          ];
        };
      };
    };
  };

  swapDevices = lib.singleton ({
    device = "/dev/disk/by-uuid/137605d3-5e3f-47c8-8070-6783ce651932";
  });

  system.stateVersion = "21.05";
}
