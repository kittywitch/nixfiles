{config,lib,...}: let
  inherit (lib.modules) mkForce mkMerge;
in {
  services.gpg-agent = {
    enable = mkForce false;
    pinentryFlavor = null;
  };

  home.file."${config.programs.gpg.homedir}/gpg-agent.conf".text = mkMerge [
    config.services.gpg-agent.extraConfig
    "pinentry-program /opt/homebrew/bin/pinentry-mac"
  ];
}
