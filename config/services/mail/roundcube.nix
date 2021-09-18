{ config, lib, ... }: with lib; {
  services.roundcube = {
    enable = true;
    hostName = "mail.${config.network.dns.domain}";
    extraConfig = ''
      $config['default_host'] = "ssl://${config.network.addresses.public.domain}";
      $config['smtp_server'] = "ssl://${config.network.addresses.public.domain}";
      $config['smtp_port'] = "465";
      $config['product_name'] = "kittywitch mail";
    '';
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
