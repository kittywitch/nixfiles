{
  pkgs,
  config,
  ...
}: {
  sops.secrets.forgejo-runner-token = {
    format = "yaml";
    sopsFile = ./forgejo-runner.yaml;
  };
  virtualisation.podman.enable = true;
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
        arches = {
          x86_64-linux = [
            "ubuntu-latest:docker://node:16-bullseye"
            "ubuntu-22.04:docker://node:16-bullseye"
            "ubuntu-20.04:docker://node:16-bullseye"
            "ubuntu-18.04:docker://node:16-buster"
            "nixos-latest:docker://nixos/nix"
            "ubuntu-latest-x86_64:docker://node:16-bullseye"
            "ubuntu-22.04-x86_64:docker://node:16-bullseye"
            "ubuntu-20.04_x86_64:docker://node:16-bullseye"
            "ubuntu-18.04-x86_64:docker://node:16-buster"
            "nixos-latest-x86_64:docker://nixos/nix"
            ## optionally provide native execution on the host:
            # "native:host"
          ];
          aarch64-linux = [
            "ubuntu-latest-aarch64:docker://node:16-bullseye"
            "ubuntu-22.04-aarch64:docker://node:16-bullseye"
            "ubuntu-20.04_aarch64:docker://node:16-bullseye"
            "ubuntu-18.04-aarch64:docker://node:16-buster"
            "nixos-latest-aarch64:docker://nixos/nix"
          ];
        };
      in
        arches.${pkgs.system};
    };
  };
}
