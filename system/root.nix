{ config, meta, lib, ... }: {
  imports = lib.optional (meta.trusted ? modules.nixos) meta.trusted.modules.nixos.deploy;

  home-manager.users.root.home.stateVersion = "20.09";
}
