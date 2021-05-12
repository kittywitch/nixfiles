{ stdenv, fetchFromGitHub, lib}:

stdenv.mkDerivation rec {
  name = "libreelec-fw-dvb";
  version = "1.4.2";

  src = fetchFromGitHub {
    repo = "dvb-firmware";
    owner = "LibreElec";
    rev = version;
    sha256 = "1xnfl4gp6d81gpdp86v5xgcqiqz2nf1i43sb3a4i5jqs8kxcap2k";
  };

  buildPhase = "";
  installPhase = ''
    mkdir -p $out/lib
    cp -rv firmware $out/lib/
  '';

  meta = with lib; {
    license = lib.licenses.unfreeRedistributableFirmware;
    maintainers = with maintainers; [ kittywitch ];
    platforms = with platforms; linux;
  };
}

