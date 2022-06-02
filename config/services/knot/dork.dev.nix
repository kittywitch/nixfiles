{ dns, lib }:

with dns.lib.combinators;

{
  SOA = {
    nameServer = "ns1";
    adminEmail = "kat@kittywit.ch";
    serial = 2021090100;
    ttl = 3600;
  };

  CAA = map (x: x // { ttl = 3600; }) (letsEncrypt "acme@kittywit.ch");

  NS = [
    "ns1.kittywit.ch."
    "rdns1.benjojo.co.uk."
    "rdns2.benjojo.co.uk."
  ];
}
