{pkgs, ...}: {
  home.packages = [pkgs.exa];

  programs.zsh.shellAliases = {
    exa = "exa --time-style long-iso";
    ls = "exa -G";
    la = "exa -Ga";
    ll = "exa -l";
    lla = "exa -lga";
  };
}
