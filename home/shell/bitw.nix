{pkgs, ...}: {
  programs.rbw = {
    enable = true;
    package = pkgs.rbw-bitw;
    settings = {
      email = "kat@kittywit.ch";
      base_url = "https://vault.kittywit.ch";
      identity_url = null;
      lock_timeout = 3600;
    };
  };
}
