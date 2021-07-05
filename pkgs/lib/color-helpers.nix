{ lib }: rec {
  hexChars =
    [ "0" "1" "2" "3" "4" "5" "6" "7" "8" "9" "a" "b" "c" "d" "e" "f" ];
  hexCharToInt = char:
    let
      pairs = lib.imap0 (lib.flip lib.nameValuePair) hexChars;
      idx = builtins.listToAttrs pairs;
    in
    idx.${lib.toLower char};
  hexToInt = str:
    lib.foldl (value: chr: value * 16 + hexCharToInt chr) 0
      (lib.stringToCharacters str);
  hextorgba = hex: alpha:
    (
      let
        r_hex = lib.substring 1 2 hex;
        g_hex = lib.substring 3 2 hex;
        b_hex = lib.substring 5 2 hex;
        r_dec = hexToInt r_hex;
        g_dec = hexToInt g_hex;
        b_dec = hexToInt b_hex;
      in
      "rgba(${toString r_dec}, ${toString g_dec}, ${toString b_dec}, ${toString alpha})"
    );
}
