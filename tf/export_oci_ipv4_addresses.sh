#!/usr/bin/env bash
DAIYOUSEI_IPV4="$(terraform output --raw daiyousei_public_ipv4)"
MEI_IPV4="$(terraform output --raw mei_public_ipv4)"
MAI_IPV4="$(terraform output --raw mai_public_ipv4)"

echo "Daiyousei - Flex: ${DAIYOUSEI_IPV4}"
echo "Mei - Micro: ${MEI_IPV4}"
echo "Mai - Micro: ${MAI_IPV4}"
