{pkgs, ...}: {
  programs.java = {
    enable = true;
  };
  environment.systemPackages = with pkgs; [
    prismlauncher
  ];
}
