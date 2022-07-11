{ config, lib, ... }: with lib;

{
  deploy.targets.home = {
    tf = { config, ... }: {
      imports = optional (builtins.pathExists ../services/irlmail.nix) ../services/irlmail.nix;

      dns.records.ygg_grimoire = {
        zone = "kittywit.ch.";
        domain = "grimoire.ygg";
        aaaa.address = "200:c87d:7960:916:bf0e:a0e1:3da7:4fc6";
      };

      dns.records.ygg_boline = {
        zone = "kittywit.ch.";
        domain = "boline.ygg";
        aaaa.address = "200:474d:14f7:1d21:f171:4e85:a3fa:9393";
      };
    };
  };
}
