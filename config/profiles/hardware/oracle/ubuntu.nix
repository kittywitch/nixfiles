{ sources, ... }: {
  imports = with import (sources.tf-nix + "/modules"); [
    nixos.ubuntu-linux
  ];
}
