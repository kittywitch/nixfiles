{ config, pkgs, ... }:

{
    networking.nat.enable = true;
    networking.nat.externalInterface = "ens3";
    networking.nat.internalInterfaces = [ "wg0" ];

    networking.firewall = {
        allowedUDPPorts = [ 51820 ];
    };

    networking.wireguard.interfaces = {
    wg0 = {
      ips = [ "10.100.0.1/24" ];

      listenPort = 51820;

      postSetup = ''
        ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s 10.100.0.0/24 -o eth0 -j MASQUERADE
      '';
      postShutdown = ''
        ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s 10.100.0.0/24 -o eth0 -j MASQUERADE
      '';

      privateKeyFile = "/var/secrets/wireguard-private";

      peers = [
        {
          publicKey = "{client public key}";
          allowedIPs = [ "10.100.0.2/32" ];
        }
      ];
    };
  };
}