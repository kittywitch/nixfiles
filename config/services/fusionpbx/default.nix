{ config, pkgs, tf, lib, ... }: with lib;

{
  deploy.tf.dns.records.services_fusionpbx = {
    tld = config.network.dns.tld;
    domain = "pbx";
    cname.target = "${config.network.addresses.private.domain}.";
  };

  kw.secrets.variables = mapListToAttrs (field:
  nameValuePair "fusionpbx-${field}" {
      path = "services/fusionpbx";
      inherit field;
  }) ["username" "password"];

  secrets.files.fusionpbx_env = {
    text = ''
      USER_NAME=${tf.variables.fusionpbx-username.ref}
      USER_PASSWORD=${tf.variables.fusionpbx-password.ref}
    '';
    owner = "fusionpbx";
    group = "fusionpbx";
  };

  security.acme.certs.services_fusionpbx = {
    domain = "pbx.${config.network.dns.domain}";
    group = "fusionpbx";
    dnsProvider = "rfc2136";
    credentialsFile = config.secrets.files.dns_creds.path;
    postRun = "systemctl restart nginx";
  };

  services.fusionpbx = {
    enable = true;
    openFirewall = true;
    useLocalPostgreSQL = true;
    environmentFile = config.secrets.files.fusionpbx_env.path;
    hardphones = true;
    useACMEHost = "services_fusionpbx";
    domain = "pbx.${config.network.dns.domain}";
    package = with pkgs; fusionpbxWithApps [ fusionpbx-apps.sms ];
    freeSwitchPackage = with pkgs; freeswitch;
  };

  services.nginx.virtualHosts."altar.kittywit.ch" = {
    locations = {
      "app/sms/hook/" = {
        proxyPass = "http://pbx.kittywit.ch/app/sms/hook";
      };
    };
  };
}
