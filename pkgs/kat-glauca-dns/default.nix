{ pkgs, curl, coreutils, writeShellScriptBin }:

writeShellScriptBin "kat-glauca-dns" ''
  #!/usr/bin/env bash
  set -eu

  ip4=$(${curl}/bin/curl -s --ipv4 https://dns.glauca.digital/checkip)
  ip6=$(${curl}/bin/curl -s --ipv6 https://dns.glauca.digital/checkip)
  source $passFile
  echo "$ip4, $ip6"
    ${curl}/bin/curl -u ''${user}:''${pass} --data-urlencode "hostname=''${hostname}" --data-urlencode "myip=''${ip4}" "https://dns.glauca.digital/nic/update"
  echo ""
    ${curl}/bin/curl -u ''${user}:''${pass} --data-urlencode "hostname=''${hostname}" --data-urlencode "myip=''${ip6}" "https://dns.glauca.digital/nic/update"
''
