_: {
  services.syncthing = {
    enable = true;
    openDefaultPorts = true;
    user = "kat";
    dataDir = "/home/kat";
  };
}
