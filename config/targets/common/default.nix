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
  variables.hcloud-token = {
    externalSecret = true;
  };

  providers.hcloud = { inputs.token = config.variables.hcloud-token.ref; };

  dns.zones."kittywit.ch." = { provider = "dns"; };

  providers.dns = {
    inputs.update = {
      server = "ns1.as207960.net";
      key_name = config.variables.rfc2136-key.ref;
      key_secret = config.variables.rfc2136-secret.ref;
      key_algorithm = "hmac-sha512";
    };
  };
}
