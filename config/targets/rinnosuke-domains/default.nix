{ config, ... }:

let rinnosuke = config.network.nodes.rinnosuke; in {
  deploy.targets.rinnosuke-domains.tf = {
    dns.records = {
      node_public_rinnosuke_v4 = {
        tld = rinnosuke.network.dns.tld;
        domain = rinnosuke.networking.hostName;
        a.address = rinnosuke.network.addresses.public.nixos.ipv4.address;
      };
      node_public_rinnosuke_v6 = {
        tld = rinnosuke.network.dns.tld;
        domain = rinnosuke.networking.hostName;
        aaaa.address = rinnosuke.network.addresses.public.nixos.ipv6.address;
      };
    };
  };
}
