{ dns }:

with dns.lib.combinators;

{
  SOA = {
    nameServer = "ns1";
    adminEmail = "kat@kittywit.ch";
    serial = 0;
  };

  NS = [
    "ns1.kittywit.ch."
    "ns2.kittywit.ch."
  ];
}
