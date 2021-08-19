{ config, ... }:

{
  home.file = {
    ".xkb/symbols/us_gbp_map".text = ''
      default partial alphanumeric_keys
      xkb_symbols "basic" {
      include "us(altgr-intl)"
      name[Group1] = "English (US, international with pound sign)";
      key <AD03> { [ e, E, EuroSign, cent ] };
      key <AE03> { [ 3, numbersign, sterling] };
      };
    '';
  };
}
