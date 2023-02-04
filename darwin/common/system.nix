_: {
  services.activate-system.enable = true;
  system = {
    defaults = {
      SoftwareUpdate.AutomaticallyInstallMacOSUpdates = true;
      NSGlobalDomain = {
        ApplePressAndHoldEnabled = true;
        AppleInterfaceStyleSwitchesAutomatically = true;
        AppleShowAllFiles = true;
        AppleShowAllExtensions = true;
      };
      dock = {
        autohide = true;
        orientation = "left";
        tilesize = 32;
        wvous-tl-corner = 1;
        wvous-tr-corner = 10;
        wvous-bl-corner = 4;
        wvous-br-corner = 14;
      };
      finder = {
        CreateDesktop = false;
        ShowPathbar = true;
        ShowStatusBar = true;
        AppleShowAllFiles = true;
        AppleShowAllExtensions = true;
      };
      loginwindow = {
        GuestEnabled = false;
      };
    };
    keyboard = {
      enableKeyMapping = true;
      remapCapsLockToControl = true;
      userKeyMapping = [
        {
          HIDKeyboardModifierMappingSrc = 30064771129;
          HIDKeyboardModifierMappingDst = 30064771299;
        }
      ];
    };
  };
}
