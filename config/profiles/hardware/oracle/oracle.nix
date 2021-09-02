{ config, sources, ... }: {
  imports = with import (sources.tf-nix + "/modules"); [
    nixos.oracle-linux
  ];
}
