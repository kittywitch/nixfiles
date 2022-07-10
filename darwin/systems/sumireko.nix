{ config, pkgs, lib, inputs, meta, ... }: {
  imports = with meta; [
    hardware.aarch64-darwin
    darwin.base
    darwin.kat
  ];
  
  security.pam.enableSudoTouchIdAuth = true;

  homebrew = {
    brewPrefix = "/opt/homebrew/bin";
    casks = [
      "element"
      "visual-studio-code"
      "firefox"
      "telegram"
      "discord"
    ];
  };

  environment.systemPackages = with pkgs; [
    awscli
    jq
  ];

  system.stateVersion = 4;
}
