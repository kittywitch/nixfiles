{config, ...}: {
  services.gpg-agent.pinentryFlavor = null;

  home.file."${config.programs.gpg.homedir}/gpg-agent.conf".text = ''
    pinentry-program /opt/homebrew/bin/pinentry-mac
  '';
}
