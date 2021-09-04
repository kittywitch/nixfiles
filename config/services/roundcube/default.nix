{ config, ... }: {
  services.roundcube = {
    enable = true;
    hostName = "mail.${config.network.dns.domain}";
  };

  deploy.tf.dns.records.services_roundcube = {
    inherit (config.network.dns) zone;
    domain = "mail";
    cname = { inherit (config.network.addresses.public) target; };
  };
}
