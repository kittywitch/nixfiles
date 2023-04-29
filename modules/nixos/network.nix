{
  config,
  lib,
  pkgs,
  meta,
  ...
}:
with lib; {
  options.deploy.system = mkOption {
    type = types.unspecified;
    readOnly = true;
  };
  config = {
    deploy.system = config.system.build.toplevel;

    networking.domain = "inskip.me";

    networking.firewall = {
      trustedInterfaces = ["tailscale0"];
      allowedTCPPorts = [5200];
      allowedUDPPorts = [config.services.tailscale.port];
    };

    services.tailscale.enable = true;
  };
}
