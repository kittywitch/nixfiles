{ lib }: { config, networkFilter ? [ ], addresses ? [ ], block }: with lib;

let
  networks = config.network.addresses;
  filteredNetworks = filterAttrs (n: v: elem n networkFilter && v.enable) networks;
  networkValues = attrValues filteredNetworks;
  addressList = concatMap (n: n.out.addressList) networkValues;
  hostBlocks = map (host: nameValuePair host block) addressList;
in listToAttrs hostBlocks
