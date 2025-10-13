{
  pkgs,
  config,
  options,
  lib,
  ...
}: {
  config = let
    inherit (lib.attrsets) optionalAttrs;
    colmenaTag = {
      deployment.tags = ["forgejo-runner"];
    };
  in
    (optionalAttrs (options ? deployment) colmenaTag)
    // {
      sops.secrets = {
        forgejo-runner-token = {
          format = "yaml";
          sopsFile = ./forgejo-runner.yaml;
        };
      };
      virtualisation.podman = {
        enable = true;
        defaultNetwork.settings = {
          dns_enabled = true;
          ipv6_enabled = true;
        };
      };
      users.groups.gitea-runner = {};
      users.users.gitea-runner = {
        isSystemUser = true;
        group = "gitea-runner";
      };
      networking.firewall.interfaces."podman*".allowedUDPPorts = [53];
      services.gitea-actions-runner = {
        package = pkgs.forgejo-actions-runner;
        instances.default = {
          enable = true;
          name = config.networking.hostName;
          url = "https://git.kittywit.ch";
          # Obtaining the path to the runner token file may differ
          # tokenFile should be in format TOKEN=<secret>, since it's EnvironmentFile for systemd
          tokenFile = config.sops.secrets.forgejo-runner-token.path;
          labels = let
            prefix = "docker://ghcr.io/catthehacker/ubuntu:act-";
            arches = {
              x86_64-linux = [
                "ubuntu-latest:${prefix}-latest"
                "ubuntu-22.04:${prefix}-22.04"
                "ubuntu-20.04:${prefix}-20.04"
                "ubuntu-18.04:${prefix}-18.04"
                "nixos-latest:docker://nixos/nix"
                "ubuntu-latest-x86_64:${prefix}-latest"
                "ubuntu-22.04-x86_64:${prefix}-22.04"
                "ubuntu-20.04_x86_64:${prefix}-20.04"
                "ubuntu-18.04-x86_64:${prefix}-18.04"
                "nixos-latest-x86_64:docker://nixos/nix"
                ## optionally provide native execution on the host:
                # "native:host"
              ];
              aarch64-linux = [
                "ubuntu-latest-aarch64:${prefix}-latest"
                "ubuntu-22.04-aarch64:${prefix}-22.04"
                "ubuntu-20.04_aarch64:${prefix}-20.04"
                "ubuntu-18.04-aarch64:${prefix}-18.04"
                "nixos-latest-aarch64:docker://nixos/nix"
              ];
            };
          in
            arches.${pkgs.system};
        };
      };
    };
}
