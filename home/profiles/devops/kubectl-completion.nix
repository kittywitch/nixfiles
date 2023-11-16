_: {
  programs = {
    zsh = {
      initExtra = ''
        source <(kubectl completion zsh)
      '';
    };
  };
}
