{ dns, nameServer }: with dns.lib.combinators; {

  SOA = {
    inherit nameServer;
    adminEmail = "admin@kittywit.ch";
    serial = 2026020800;
  };

  useOrigin = false;

  NS = [
    "mei.kittywit.ch"
    "mai.kittywit.ch"
  ];

  A = [ ];
  AAAA = [ ];

  subdomains = rec {
  };
}
