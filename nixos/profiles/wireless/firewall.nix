_: {
  firewall = {
    allowedUDPPorts = [5353]; # MDNS
    allowedUDPPortRanges = [
      {
        from = 32768;
        to = 60999;
      }
    ]; # Chromecast
  };
}
