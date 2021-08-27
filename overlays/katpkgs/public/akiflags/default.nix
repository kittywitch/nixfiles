{ lib, stdenv, fetchurl, python36, installShellFiles }:

stdenv.mkDerivation {
  pname = "akiflags";
  version = "0.0.1";

  buildInputs = [
    python36
  ];

  unpackPhase = "true";

  installPhase = ''
    mkdir -p $out/bin
    cp ${./flags.py} $out/bin/akiflags
    chmod +x $out/bin/akiflags
  '';
}
