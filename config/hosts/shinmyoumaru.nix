{ config, meta, pkgs, lib, modulesPath, ... }: with lib; {
  imports = with meta; [
    profiles.hardware.raspi
    profiles.network
    services.dnscrypt-proxy
    services.dht22-exporter
    (modulesPath + "/installer/sd-card/sd-image-raspberrypi.nix")
  ];

  home-manager.users.kat.programs.neovim.enable = mkForce false;
  programs.mosh.enable = mkForce false;

  boot.supportedFilesystems = mkForce (singleton "ext4");

  deploy.tf = {
    resources.shinmyoumaru = {
      provider = "null";
      type = "resource";
      connection = {
        port = head config.services.openssh.ports;
        host = config.network.addresses.private.nixos.ipv4.address;
      };
    };
  };

  networking = {
    useDHCP = true;
    interfaces.eth0.ipv4.addresses = singleton {
      inherit (config.network.addresses.private.nixos.ipv4) address;
      prefixLength = 24;
    };
    defaultGateway = config.network.privateGateway;
  };

  network = {
    addresses = {
      private = {
        enable = true;
        nixos = {
          ipv4.address = "192.168.1.33";
          # TODO ipv6.address
        };
      };
    };
    yggdrasil = {
      enable = true;
      pubkey = "70c18030247e98fdffe4fd81f5fa8c7c4ed43fd6a4fb2b5ef7af0a010d08f63c";
      address = "200:691b:b4fb:6987:711f:bde:9b5c:8af3";
      listen.enable = false;
      listen.endpoints = [ "tcp://0.0.0.0:0" ];
    };
    firewall = {
      private.interfaces = singleton "yggdrasil";
      public.interfaces = singleton "eth0";
    };
  };

  system.stateVersion = "21.11";
}
