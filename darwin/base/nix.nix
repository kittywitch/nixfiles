_: {
  services.nix-daemon.enable = true;
  nix = {
    extraOptions = ''
      extra-platforms = x86_64-darwin aarch64-darwin
    '';
  };
}
