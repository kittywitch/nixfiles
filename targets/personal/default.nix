{ config, ... }:

{
  variables.phone_ygg = {
    type = "string";
    value.shellCommand = "bitw get infra/phone-ygg";
  };

  dns.records.kittywitch_net_grimoire = {
    tld = "kittywit.ch.";
    domain = "grimoire.net";
    aaaa.address = config.variables.phone_ygg.ref;
  };
}
