_: {
  boot.loader = {
    timeout = null;
    grub = {
      enable = true;
      useOSProber = true;
      splashImage = ./splash.jpg;
      extraConfig = ''
        set color_normal=black/black
        set menu_color_normal=black/black
        set menu_color_highlight=magenta/cyan
      '';
      memtest86.enable = true;
      extraEntries = ''
        if [ ''${grub_platform} == "efi" ]; then
          menuentry 'UEFI Firmware Settings' --id 'uefi-firmware' {
            fwsetup
          }
        fi
        menuentry "System restart" {
          echo "System rebooting..."
          reboot
        }
        menuentry "System shutdown" {
          echo "System shutting down..."
          halt
        }
      '';
    };
  };
}
