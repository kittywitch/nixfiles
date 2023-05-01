_: {
    services.kubernetes = {
        roles = ["master" "node"];
        apiserver.enable = true;
        controllerManager.enable = true;
        scheduler.enable = true;
        addonManager.enable = true;
        easyCerts = true;
        addons.dns.enable = true; # CoreDNS
        proxy.enable = true;
        flannel.enable = true;
    };
}