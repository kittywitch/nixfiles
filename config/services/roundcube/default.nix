{ config, lib, ... }: with lib; {
  services.roundcube = {
    enable = true;
    hostName = "mail.${config.network.dns.domain}";
  };

  services.nginx.virtualHosts."mail.${config.network.dns.domain}" = {
    useACMEHost = "dovecot_domains";
    enableACME = mkForce false;
  };

  users.users.nginx.extraGroups = singleton "postfix";

  deploy.tf.dns.records.services_roundcube = {
    inherit (config.network.dns) zone;
    domain = "mail";
    cname = { inherit (config.network.addresses.public) target; };
  };
}
