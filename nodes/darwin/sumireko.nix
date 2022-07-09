{ config, pkgs, lib, inputs, meta, ... }: {
  imports = with meta; [
      profiles.hardware.aarch64-darwin
      profiles.darwin
      users.kat.darwin
      users.kat.dev
  ];
  
  security.pam.enableSudoTouchIdAuth = true;

  homebrew = {
    brewPrefix = "/opt/homebrew/bin";
    casks = [
      "element"
      "visual-studio-code"
      "firefox"
      "discord"
    ];
  };

  environment.systemPackages = with pkgs; [
    awscli
    jq
  ];

  system.stateVersion = 4;
}
