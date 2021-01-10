{ stdenv, fetchFromGitHub, kernel }:

let
  version = "0.0.18";
  rev = "765b05cdbd4de854c05f771c954ecee0e019d734";
  sha256 = "0ayn8128i0bfwzcmkn0x2alfplbsmvp0c63z56w11ywyysf342qw"; # TODO add this
in

stdenv.mkDerivation {
  name = "vendor-reset-${version}-${kernel.version}";
  inherit version;

  src = fetchFromGitHub {
    owner = "gnif";
    repo = "vendor-reset";
    inherit rev;
    inherit sha256;
  };

  nativeBuildInputs = kernel.moduleBuildDependencies;
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