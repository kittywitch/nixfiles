{pkgs, ...}: {
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      "custom.kubeprompt" = {
        command = ''${pkgs.kubeprompt}/bin/kubeprompt -f default'';
        when = ''test "$KUBECONFIG" '';
      };
    };
  };
}
