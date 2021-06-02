{ stdenv, fetchFromGitHub, lib, ncurses }:

stdenv.mkDerivation rec {
  pname = "wezterm-terminfo";
  version = "20210502-154244-3f7122cb";

  src = fetchFromGitHub {
    owner = "wez";
    repo = pname;
    rev = version;
    sha256 = "9HPhb7Vyy5DwBW1xeA6sEIBmmOXlky9lPShu6ZoixPw=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    ncurses
  ];

  buildPhase = "";
  installPhase = ''
    mkdir -p $out/share/terminfo/w
    ${ncurses}/bin/tic -x -o $out/share/terminfo $src/termwiz/data/wezterm.terminfo
    mkdir -p $out/nix-support
    echo "$out" >> $out/nix-support/propagated-user-env-packages
  '';

  meta = with lib; {
    license = lib.licenses.mit;
    maintainers = with maintainers; [ kittywitch ];
    platforms = with platforms; linux;
  };
}

