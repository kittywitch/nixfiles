{pkgs, ...}: {
  programs.java = {
    enable = false;
  };
  environment.systemPackages = with pkgs; [
    #prismlauncher
  ];
}
