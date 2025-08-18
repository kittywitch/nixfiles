_: {
  microvm = {
    host.enable = true;
  };

  networking.useNetworkd = true;

  systemd.network.netdevs."10-microvm".netdevConfig = {
    Kind = "bridge";
    Name = "microvm";
  };

  # Internet for microVMs!
  networking.nat = {
    enable = true;
    # NAT66 exists and works. But if you have a proper subnet in
    # 2000::/3 you should route that and remove this setting:
    enableIPv6 = true;

    # Change this to the interface with upstream Internet access
    externalInterface = "enp0s6";
    # The bridge where you want to provide Internet access
    internalInterfaces = ["microvm"];
  };

  # MicroVM
  systemd.network.networks."10-microvm" = {
    matchConfig.Name = "microvm";
    networkConfig = {
      DHCPServer = true;
      IPv6SendRA = true;
    };
    addresses = [
      {
        addressConfig.Address = "10.0.0.1/24";
      }
      {
        addressConfig.Address = "fd12:3456:789a::1/64";
      }
    ];
    ipv6Prefixes = [
      {
        ipv6PrefixConfig.Prefix = "fd12:3456:789a::/64";
      }
    ];
  };

  # Attach to microVMs
  systemd.network.networks."11-microvm" = {
    matchConfig.Name = "vm-*";
    # Attach to the bridge that was configured above
    networkConfig.Bridge = "microvm";
  };

  # Allow inbound traffic for the DHCP server
  networking.firewall.allowedUDPPorts = [67];

  users.users = {
    # allow microvm access to zvol
    microvm.extraGroups = ["disk"];
  };
}
