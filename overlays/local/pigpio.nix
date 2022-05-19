{ stdenv, glibc, fetchFromGitHub, cmake, writeTextFile
,
}:

let
  version = "79";
  pname = "pigpio";

  pkgConfig = writeTextFile {
    name = "${pname}.pc";
    text = ''
      prefix=@out@
      exec_prefix=''${prefix}
      includedir=''${prefix}/include
      libdir=''${prefix}/lib

      Name: pigpio
      Description: GPIO library for Raspberry Pi computers
      Version: ${version}
      Libs: -L''${libdir} -lpigpio -lpthread -lm
      Cflags: -I''${includedir}
    '';
  };

in
  stdenv.mkDerivation rec {
    inherit pname version;

    src = fetchFromGitHub {
      owner = "joan2937";
      repo = pname;
      rev = "v${version}";
      sha256 = "0wgcy9jvd659s66khrrp5qlhhy27464d1pildrknpdava19b1r37";
    };

    patches = [
      ./Pi4Revision.patch
    ];

    nativeBuildInputs = [
      cmake
    ];

    buildInputs = [
      glibc
    ];

    meta = with stdenv.lib; {
      description = "GPIO library for the Raspberry Pi";
      homepage = "http://abyz.me.uk/rpi/pigpio/index.html";
      license = licenses.unlicense;
      platforms = platforms.unix;
    };

    installPhase = ''
      make install
      mkdir -p $out/lib/pkgconfig
      substitute ${pkgConfig} $out/lib/pkgconfig/pigpio.pc --subst-var out
    '';
  }
