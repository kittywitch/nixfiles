{ config, pkgs, lib, ... }:
{
  # Set some necessary sysctls
  boot.kernel.sysctl = {
    "net.ipv6.conf.all.forwarding" = 1;
    "net.ipv4.conf.all.forwarding" = 1;
    # k8s opens a LOT of files, raise the total number of openable files so we don't end up getting issues in userspace
    "fs.inotify.max_user_instances" = 16384;
    "vm.max_map_count" = 524288;
    "vm.swappiness" = 10;
  };

  systemd.services.containerd = {
    path = with pkgs; [ containerd kmod zfs runc iptables ];
  };

  virtualisation.containerd.settings = {
    plugins."io.containerd.grpc.v1.cri" = {
      cni.bin_dir = "/opt/cni/bin";
    };
  };

  # disable creating the CNI directory (calico will make it for us)
  environment.etc."cni/net.d".enable = false;

  # Firewalling must be disabled for kubes.
  networking.firewall.enable = false;
  networking.nftables.enable = lib.mkForce false;

  # Useful utilities.
  environment.systemPackages = [
    # kubectl_ppc
    pkgs.kubectl pkgs.kubetail
  ];

  # Kubernetes configuration.
  services.kubernetes = {
    # because fuck PKI honestly
    easyCerts = true;
    roles = ["master" "node"];
    flannel.enable = false;
    # where can we contact the (an) apiserver?
    apiserverAddress = "https://yukari.int.kittywit.ch:6443";
    # where can we contact the orchestrator?
    masterAddress = "yukari.int.kittywit.ch";

    #Â ipv4 cidr should be before ipv6 otherwise apps that make assumptions break horribly when binding to ipv4 interfaces and then attempting to contact themselves over ipv6
    clusterCidr = "172.18.0.0/16,fc00:abc1::/48";

    # define dns separately
    addons.dns.enable = false;
    #Â dns on ipv6 though
    #addons.dns.clusterIp = "fc00:abc0::254";
    #Â define newer coredns
    #addons.dns.coredns = {
    #    # AMD64 version.
    #    # TODO upgrade to 1.8 (requires a new configmap)
    #    #Â (1.7 removes upstream directive, should just be a case of removing that)
    #    imageName = "coredns/coredns";
    #    imageDigest = "sha256:2044ffefe18e2dd3d6781e532119603ee4e8622b6ba38884dc7ab53325435151";
    #    finalImageTag = "1.6.9";
    #    sha256 = "0j5gj82jbqylapfrab61qdhm4187pqphyz244n31ik05wd5l8n17";
    #};

    apiserver = {
      # address to advertise the apiserver at, must be reachable by the rest of the cluster
      advertiseAddress = "192.168.1.154";
      #Â privileged pods are required to run cluster services like MetalLB and longhorn
      allowPrivileged = true;
      # bind to ipv4 & ipv6
      bindAddress = "::";
      # needed otherwise we end up with a cert that isn't valid for ipv6
      extraSANs = [ "172.19.0.1" "fc00:abc0::1" ];
      serviceClusterIpRange = "172.19.0.0/16,fc00:abc0::/112";
      # allow all ports (this is a really bad idea don't do this with untrusted workloads)
      extraOpts = "--service-node-port-range=1-65535";
      #extraOpts = "--service-node-port-range=1-65535";
      enableAdmissionPlugins = [
        "NamespaceLifecycle" "LimitRanger" "ServiceAccount" "TaintNodesByCondition" "Priority" "DefaultTolerationSeconds"
        "DefaultStorageClass" "StorageObjectInUseProtection" "PersistentVolumeClaimResize" "RuntimeClass" "CertificateApproval" "CertificateSigning"
        "CertificateSubjectRestriction" "DefaultIngressClass" "MutatingAdmissionWebhook" "ValidatingAdmissionWebhook" "ResourceQuota"
      ];
    };
    controllerManager = {
      # bind to localhost ipv6
      bindAddress = "::1";
      extraOpts = "--service-cluster-ip-range=172.19.0.0/16,fc00:abc0::/64 --node-cidr-mask-size-ipv4=24 --node-cidr-mask-size-ipv6=64";
    };
    kubelet = {
      featureGates = [ "NodeSwap" ];
      clusterDns = "fc00:abc0::254";
      networkPlugin = "cni";
     cni.configDir = "/etc/cni/net.d";
      nodeIp = "192.168.1.154,2a00:23c7:c5ad:6e00::c2e";# "10.0.0.1,2a02:8010:61d0:beef:428d:5cff:fe4e:6a2c";
      extraOpts = ''
        --root-dir=/var/lib/kubelet \
        --fail-swap-on=false \
        --cni-bin-dir=/opt/cni/bin \
      '';
    };
    proxy = {
      # bind to ipv6
      bindAddress = "::";
    };
  };

systemd.services.kubelet = {
    preStart = pkgs.lib.mkForce ''
      ${lib.concatMapStrings (img: ''
        echo "Seeding container image: ${img}"
        ${if (lib.hasSuffix "gz" img) then
          ''${pkgs.gzip}/bin/zcat "${img}" | ${pkgs.containerd}/bin/ctr -n k8s.io image import -''
        else
          ''${pkgs.coreutils}/bin/cat "${img}" | ${pkgs.containerd}/bin/ctr -n k8s.io image import -''
        }
      '') config.services.kubernetes.kubelet.seedDockerImages}
      ${lib.concatMapStrings (package: ''
        echo "Linking cni package: ${package}"
        ln -fs ${package}/bin/* /opt/cni/bin
      '') config.services.kubernetes.kubelet.cni.packages}
      '';
  };
}
