{ meta, config, pkgs, lib, ... }:

{
  programs.ssh = {
    enable = true;
    controlMaster = "auto";
    controlPersist = "10m";
    hashKnownHosts = true;
    compression = true;
    matchBlocks = lib.mapAttrs (host: data: {
      port = lib.head meta.networks.tailscale.member_configs.${host}.services.openssh.ports;
      hostname = data.ipv4;
      forwardAgent = true;
      extraOptions = {
          RemoteForward = (lib.concatStringsSep " " [
            "/run/user/1000/gnupg/S.gpg-agent"
            "/run/user/1000/gnupg/S.gpg-agent.extra"
          ]);
      };
    }) meta.networks.tailscale.members;
  };
}
