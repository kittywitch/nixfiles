{ stdenv, fetchFromGitHub, kernel, pkgs }:

let
  version = "0.1.1";
  rev = "225a49a40941e350899e456366265cf82b87ad25";
  sha256 =
    "071zd8slra0iqsvzqpp6lcvg5dql5hkn161gh9aq34wix7pwzbn5";

in stdenv.mkDerivation {
  name = "vendor-reset-${version}-${kernel.version}";
  inherit version;

  src = fetchFromGitHub {
    owner = "gnif";
    repo = "vendor-reset";
    inherit rev;
    inherit sha256;
  };

  hardeningDisable = [ "pic" ];

  makeFlags = [
    "KVER=${kernel.modDirVersion}"
    "KDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "INSTALL_MOD_PATH=$(out)"
  ];

  meta = with stdenv.lib; {
    license = [ licenses.gpl2Only ];
    platforms = [ "i686-linux" "x86_64-linux" ];
    description = "Vendor Reset kernel module";
    homepage = "https://github.com/gnif/vendor-reset";
  };
}
