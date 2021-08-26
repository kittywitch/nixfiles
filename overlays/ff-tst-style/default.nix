final: prev: {
  firefox-tst = final.callPackage ({ stdenv, sass }: { base16 }:

  stdenv.mkDerivation ({
    pname = "ff-tst-style";
    version = "0.0.1";

    phases = [ "buildPhase" ];

    src = ./tst.sass;

    buildInputs = [
      sass
    ];

    buildPhase = ''
      substituteAll $src tst-sub.sass
      sass tst-sub.sass $out --sourcemap=none --style expanded
    '';
  } // base16)) {};
}
