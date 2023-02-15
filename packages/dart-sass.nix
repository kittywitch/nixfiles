{ stdenv, fetchurl, autoPatchelfHook }:

stdenv.mkDerivation rec {
  pname = "dart-sass";
  version = "1.58.1";

  src = fetchurl {
    url =
      "https://github.com/sass/${pname}/releases/download/${version}/${pname}-${version}-linux-x64.tar.gz";
    sha256 = "sha256-5/mEeshCakp/eju9MhFZ8VXvHEuXGiDVtUI2UhI0XPU=";
  };

  nativeBuildInputs = [ autoPatchelfHook ];

  installPhase = ''
    mkdir -p $out/bin
    mv sass $out/bin
  '';
}
