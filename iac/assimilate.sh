#!/usr/bin/env bash

set -e
[ ! -z "$DEBUG" ] && set -x

USAGE(){
    echo "Usage: `basename $0` <server_name>"
    exit 2
}

if [ -z "$1" ]; then
    USAGE
fi

server_name="$1"
public_ip="$2"

ssh_ignore(){
    ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no $*
}

ssh_victim(){
    ssh_ignore root@"${public_ip}" $*
}

mkdir -p "./hosts/${server_name}"
echo "${public_ip}" >> ./hosts/"${server_name}"/public-ip

until ssh_ignore "root@${server_name}" uname -av
do
    sleep 30
done

scp -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no "root@${server_name}:/etc/nixos/hardware-configuration.nix" "../systems/${server_name}.nix" ||:


rm -f ./hosts/"${server_name}"/default.nix
cat <<-EOC >> ./hosts/"${server_name}"/default.nix
{ ... }: {
  imports = [ ./hardware-configuration.nix ];

  boot.cleanTmpDir = true;
  zramSwap.enable = true;
  networking.hostName = "${server_name}";
  services.openssh.enable = true;
  services.tailscale.enable = true;
  networking.firewall.checkReversePath = "loose";
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM6NPbPIcCTzeEsjyx0goWyj6fr2qzcfKCCdOUqg0N/v" # alrest
  ];
  system.stateVersion = "23.05";
}
EOC

git add .
git commit -sm "add machine ${server_name}: ${public_ip}"
nix build .#nixosConfigurations."${server_name}".config.system.build.toplevel

export NIX_SSHOPTS='-o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no'
nix-copy-closure -s root@"${public_ip}" $(readlink ./result)
ssh_victim nix-env --profile /nix/var/nix/profiles/system --set $(readlink ./result)
ssh_victim $(readlink ./result)/bin/switch-to-configuration switch

git push