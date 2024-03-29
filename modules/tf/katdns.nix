{ config, meta, lib, ... }:  with lib; {

  variables.katdns-address = {
    value.shellCommand = "${meta.secrets.command} secrets/katdns -f address";
    type = "string";
    sensitive = true;
  };
  variables.katdns-name = {
    value.shellCommand = "${meta.secrets.command} secrets/katdns -f username";
    type = "string";
    sensitive = true;
  };
  variables.katdns-key = {
    value.shellCommand = "${meta.secrets.command} secrets/katdns -f password";
    type = "string";
    sensitive = true;
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
