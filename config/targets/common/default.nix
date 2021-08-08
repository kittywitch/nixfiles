{ config, ... }:

{
  commandPrefix = "pass";
  folderPrefix = "secrets";
  folderDivider = "/";

  variables.hcloud_token = {
    type = "string";
    value.shellCommand = "bitw get infra/hcloud_token";
  };

  variables.glauca_key = {
    type = "string";
    value.shellCommand = "bitw get infra/rfc2136 -f username";
  };

  variables.glauca_secret = {
    type = "string";
    value.shellCommand = "bitw get infra/rfc2136 -f password";
  };

  dns.zones."kittywit.ch." = { provider = "dns"; };

  providers.hcloud = { inputs.token = config.variables.hcloud_token.ref; };

  providers.dns = {
    inputs.update = {
      server = "ns1.as207960.net";
      key_name = config.variables.glauca_key.ref;
      key_secret = config.variables.glauca_secret.ref;
      key_algorithm = "hmac-sha512";
    };
  };
}
