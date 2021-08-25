{ config, ... }:

{
  deploy.targets.home = {
    tf = { config, ... }: {
      dns.records.ygg_grimoire = {
        tld = "kittywit.ch.";
        domain = "grimoire.net";
        aaaa.address = "200:c87d:7960:916:bf0e:a0e1:3da7:4fc6";
      };

      dns.records.ygg_boline = {
        tld = "kittywit.ch.";
        domain = "boline.net";
        aaaa.address = "200:474d:14f7:1d21:f171:4e85:a3fa:9393";
      };
    };
  };
}
