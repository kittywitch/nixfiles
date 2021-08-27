{ lib }: { config, networkFilter ? [ ], addresses ? [ ], block }: with lib;

let
  networks = config.network.addresses;
  filteredNetworks = filterAttrs (n: v: elem n networkFilter) networks;
  networkValues = attrValues filteredNetworks;
  addressList'= concatMap (n: n.out.identifierList) networkValues;
  addressList = map(n: builtins.unsafeDiscardStringContext n) addressList';
  hostBlocks = map (host: nameValuePair host block) addressList;
in
listToAttrs hostBlocks
