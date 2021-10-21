{ config, lib, pkgs, modulesPath, tf, meta, ... }: with lib; {
  imports = with meta; [
    (modulesPath + "/profiles/qemu-guest.nix")
    services.dnscrypt-proxy
    profiles.network
    services.nginx
    services.access
    users.kat.server
  ];


  deploy.tf = {
    resources.marisa = {
      provider = "null";
      type = "resource";
      connection = {
        port = head config.services.openssh.ports;
        host = config.network.addresses.public.nixos.ipv4.address;
      };
    };
  };

  boot = {
    loader.grub = {
      enable = true;
      version = 2;
      device = "/dev/vda";
    };
    initrd = {
      availableKernelModules = [ "ata_piix" "uhci_hcd" "virtio_pci" "virtio_scsi" "sr_mod" "virtio_blk" ];
    };
    kernelModules = [ "kvm-amd" ];
  };

  networking = {
    hostName = "marisa";
    nameservers = [
      "1.1.1.1"
    ];
    useDHCP = false;
    defaultGateway = "104.244.72.1";
    defaultGateway6 = {
      address = "2605:6400:30::1";
      interface = "ens3";
    };
    interfaces.ens3 = {
      ipv4.addresses = [
        {
          inherit (config.network.addresses.public.nixos.ipv4) address;
          prefixLength = 24;
        }
      ];
      ipv6.addresses = [
        {
          inherit (config.network.addresses.public.nixos.ipv6) address;
          prefixLength = 48;
        }
      ];
    };
  };

  network = {
    addresses.public = {
      enable = true;
      nixos.ipv4.address = "104.244.72.5";
      nixos.ipv6.address = "2605:6400:30:eed1:6cf7:bbfc:b4e:15c0";
    };
    yggdrasil = {
      enable = true;
      pubkey = "3b171319fbb6be1716c99f36b83a70346ec655d99afde410a50ca61a1c278c7c";
      listen.enable = true;
      listen.endpoints = [ "tcp://${config.network.addresses.public.nixos.ipv4.address}:52969" "tcp://[${config.network.addresses.public.nixos.ipv6.address}]:52969" ];
    };
    firewall = {
      public = {
        interfaces = singleton "ens3";
        tcp.ports = singleton 62969;
      };
      private.interfaces = singleton "yggdrasil";
    };
  };

  # Youko WG
  networking.wireguard.interfaces.wg-youko = {
    ips = [
      "10.42.68.1/24"
    ];
    listenPort = 51219;
    peers = [
      {
        allowedIPs = [
          "10.42.68.1/24"
        ];
        publicKey = "nc7mpg2tbawWR9xjFsk/loxAMtRhEZ49PCJXNYk/Qm8=";
      }
    ];
    privateKeyFile = config.secrets.files.wg-youko-privkey.file;
  };

  kw.secrets.variables.wg-youko-privkey = {
    path = "secrets/wireguard";
    field = "youko-privkey";
  };
  secrets.files.wg-youko-privkey = {
    text = "${tf.variables.wg-youko-privkey.ref}";
  };

  fileSystems."/" ={
    device = "/dev/disk/by-uuid/6ed3e886-d390-433f-90ac-2b37aed9f15f";
    fsType = "ext4";
  };

  swapDevices = [
    { device = "/dev/disk/by-uuid/ba1425d4-8c18-47aa-b909-65bb710be400"; }
  ];

  system.stateVersion = "21.11";
}
