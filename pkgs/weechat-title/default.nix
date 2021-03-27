{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "title.py";
  version = "2011-11-15";
  sha256 = "1h8mxpv47q3inhynlfjm3pdjxlr2fl06z4cdhr06kpm8f7xvz56p";

  src = fetchurl {
    name = pname;
    url = "https://weechat.org/files/scripts/title.py";
    sha256 = sha256;
  };

  unpackPhase = "true";

  installPhase = ''
    install -D $src $out/share/title.py
  '';

  passthru.scripts = [ pname ];
}
