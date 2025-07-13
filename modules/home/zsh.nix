{ lib, ... }: {
  programs.zsh.initContent = lib.mkBefore ''
    source /etc/static/zshrc
  '';
}
