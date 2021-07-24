{ lib, stdenv, fetchurl, python36, pythonPackages, installShellFiles }:

stdenv.mkDerivation {
  name = "akiflags";
  buildInputs = [
    (python36.withPackages (pythonPackages: with pythonPackages; [ ]))
  ];
  unpackPhase = "true";
  installPhase = ''
    mkdir -p $out/bin
    cp ${./flags.py} $out/bin/akiflags
    chmod +x $out/bin/akiflags
  '';
}
