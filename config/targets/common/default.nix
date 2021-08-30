{ config, ... }:

{
  commandPrefix = "pass";
  folderPrefix = "secrets";
  folderDivider = "/";

  variables.rfc2136-key = {
    externalSecret = true;
  };
  variables.rfc2136-secret = {
    externalSecret = true;
  };

  variables.katdns-name = {
    externalSecret = true;
  };

  variables.katdns-key = {
    externalSecret = true;
  };

  providers.katdns = {
    type = "dns";
    inputs.update = {
      server = "ns1.kittywit.ch";
      key_name = "kittywit.ch.";
      key_secret = config.variables.katdns-key.ref;
      key_algorithm = "hmac-sha512";
    };
  };

  dns.zones."kittywit.ch." = { provider = "dns.katdns"; };

  providers.dns = {
    inputs.update = {
      server = "ns1.as207960.net";
      key_name = config.variables.rfc2136-key.ref;
      key_secret = config.variables.rfc2136-secret.ref;
      key_algorithm = "hmac-sha512";
    };
  };
}
