{ config, lib, ... }: with lib;

{
  variables.katdns-address = {
    value.shellCommand = "bitw get secrets/katdns -f address";
    type = "string";
    sensitive = true;
  };
  variables.katdns-name = {
    value.shellCommand = "bitw get secrets/katdns -f username";
    type = "string";
    sensitive = true;
  };
  variables.katdns-key = {
    value.shellCommand = "bitw get secrets/katdns -f password";
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

  dns.zones = genAttrs ["kittywit.ch." "dork.dev."] (_: {
    provider = "dns.katdns";
  });
}
