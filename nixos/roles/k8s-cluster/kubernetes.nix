{
  pkgs,
  lib,
  ...
}: let
  inherit (lib.modules) mkForce;
  kubeMasterIP = "100.105.14.66";
  kubeMasterHostname = "ran.gensokyo.zone";
  kubeMasterAPIServerPort = 6443;
in {
  # packages for administration tasks
  environment.systemPackages = with pkgs; [
    kompose
    kubectl
    kubernetes
  ];

  networking = {
    firewall.enable = mkForce false;
    extraHosts = "${kubeMasterIP} ${kubeMasterHostname}";
  };

  systemd.services.etcd.preStart = ''${pkgs.writeShellScript "etcd-wait" ''
      while [ ! -f /var/lib/kubernetes/secrets/etcd.pem ]; do sleep 1; done
    ''}'';

  services.kubernetes = {
    roles = ["master" "node"];
    addons.dns.enable = true; # CoreDNS
    masterAddress = kubeMasterHostname;
    apiserverAddress = "https://${kubeMasterHostname}:${toString kubeMasterAPIServerPort}";
    apiserver = {
      securePort = kubeMasterAPIServerPort;
      advertiseAddress = kubeMasterIP;
      extraOpts = "--service-node-port-range=1-65535";
      allowPrivileged = true;
    };
  };
}
