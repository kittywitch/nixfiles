_: {
  boot = {
    plymouth = {
      enable = true;
    };
    consoleLogLevel = 0;
    kernelParams = ["quiet"];
      initrd = {
        verbose = false;
        systemd.enable = true;
      };
  };
  catppuccin.plymouth.enable = true;
}
