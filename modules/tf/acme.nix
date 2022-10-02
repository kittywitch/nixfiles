{ config, meta, lib, target, ... }: with lib;
let
  home = meta.deploy.targets.home.tf;
in lib.mkIf (target != "home") {
  acme = {
    enable = true;
        account = {
          register = lib.mkDefault false;
          emailAddress = "kat@inskip.me";
          accountKeyPem = home.resources.acme_private_key.importAttr "private_key_pem";
        };
        challenge = {
          defaultProvider = "rfc2136";
          configs.rfc2136 = {
            RFC2136_NAMESERVER = config.variables.katdns-address.ref;
            RFC2136_TSIG_KEY = config.variables.katdns-name.ref;
            RFC2136_TSIG_SECRET = config.variables.katdns-key.ref;
            RFC2136_TSIG_ALGORITHM = "hmac-sha512";
          };
        };
    };

}
