{ pkgs, lib, ... }: let
  inherit (lib.meta) getExe;
in {
  home.packages = [
    pkgs.starship-jj
  ];
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      time = {
        disabled = false;
      };
      custom.jj = {
        command = "prompt";
        format = "$output";
        ignore_timeout = true;
        shell = ["${getExe pkgs.starship-jj}" "--ignore-working-copy" "starship"];
        use_stdin = false;
        when = true;
      };
    };
  };
}
