_: {
  systemd.sleep.extraConfig = ''
    HibernateDelaySec=30m
    SuspendState=mem
  '';
  boot.kernelParams = ["mem_sleep_default=deep"];
  services.logind = {
    powerKey = "hibernate";
    powerKeyLongPress = "poweroff";
    lidSwitch = "suspend-then-hibernate";
  };
}
