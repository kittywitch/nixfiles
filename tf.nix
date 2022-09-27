{ config, meta, lib, ... }: with lib;

{
  deploy.gcroot.enable = true;

  variables.katdns-address = {
    value.shellCommand = "${meta.kw.secrets.command} secrets/katdns -f address";
    type = "string";
    sensitive = true;
  };
  variables.katdns-name = {
    value.shellCommand = "${meta.kw.secrets.command} secrets/katdns -f username";
    type = "string";
    sensitive = true;
  };
  variables.katdns-key = {
    value.shellCommand = "${meta.kw.secrets.command} secrets/katdns -f password";
    type = "string";
    sensitive = true;
  };
  acme = {
    enable = true;
        account = {
          emailAddress = "kat@inskip.me";
          accountKeyPem = home.resources.acme_private_key.importAttr "private_key_pem";
        };
        challenge = {
          defaultProvider = "rfc2136";
          configs.rfc2136 = {
            RFC2136_NAMESERVER = tf.variables.katdns-address.ref;
            RFC2136_TSIG_KEY = tf.variables.katdns-name.ref;
            RFC2136_TSIG_SECRET = tf.variables.katdns-key.ref;
            RFC2136_TSIG_ALGORITHM = "hmac-sha512";
          };
        };
    };

  providers.katdns = {
    type = "dns";
    inputs.update = {
      server = config.variables.katdns-address.ref;
      key_name = config.variables.katdns-name.ref;
      key_secret = config.variables.katdns-key.ref;
      key_algorithm = "hmac-sha512";
    };
  };

  dns.zones = genAttrs [ "inskip.me." "kittywit.ch." "dork.dev." "gensokyo.zone." ] (_: {
    provider = "dns.katdns";
  });
}
