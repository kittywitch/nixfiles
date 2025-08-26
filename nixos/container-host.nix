_: {
  networking.useNetworkd = true;

  systemd.network.netdevs."20-container".netdevConfig = {
    Kind = "bridge";
    Name = "container";
  };

  # Internet for containers!
  networking.nat = {
    enable = true;
    # NAT66 exists and works. But if you have a proper subnet in
    # 2000::/3 you should route that and remove this setting:
    enableIPv6 = true;

    # Change this to the interface with upstream Internet access
    externalInterface = "enp0s6";
    # The bridge where you want to provide Internet access
    internalInterfaces = ["container"];
  };

  # container
  systemd.network.networks."20-container" = {
    matchConfig.Name = "container";
    networkConfig = {
      DHCPServer = true;
      IPv6SendRA = true;
    };
    addresses = [
      {
        addressConfig.Address = "10.0.1.1/24";
      }
      {
        addressConfig.Address = "fd12:3456:789b::1/64";
      }
    ];
    ipv6Prefixes = [
      {
        ipv6PrefixConfig.Prefix = "fd12:3456:789b::/64";
      }
    ];
  };

  # Attach to containers
  systemd.network.networks."21-container" = {
    matchConfig.Name = "ve-*";
    # Attach to the bridge that was configured above
    networkConfig.Bridge = "container";
  };

  # Allow inbound traffic for the DHCP server
  networking.firewall.allowedUDPPorts = [67];

  users = {
    groups.container = {};
    users = {
      # allow container access to zvol
      container = {
        isSystemUser = true;
        group = "container";
        extraGroups = ["disk"];
      };
    };
  };
}
