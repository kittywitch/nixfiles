{ lib
, stdenv
, fetchFromGitHub
, meson
, ninja
, pkg-config
, scdoc
, fetchpatch
, wayland
, wayland-protocols
, libxkbcommon
, cairo
, gdk-pixbuf
, pam
}:

stdenv.mkDerivation rec {
  pname = "swaylock-effects";
  version = "2021-05-23";

  src = fetchFromGitHub {
    owner = "mortie";
    repo = "swaylock-effects";
    rev = "5cb9579faaf5662b111f5722311b701eff1c1d00";
    sha256 = "036dkhfqgk7g9vbr5pxgrs66h5fz0rwdsc67i1w51aa9v01r35ca";
  };

  postPatch = ''
    sed -iE "s/version: '1\.3',/version: '${version}',/" meson.build
  '';

  nativeBuildInputs = [ meson ninja pkg-config scdoc ];
  buildInputs = [ wayland wayland-protocols libxkbcommon cairo gdk-pixbuf pam ];

  patches = [
    (fetchpatch {
      name = "use-font-size-for-date-if-present";
      url = "https://patch-diff.githubusercontent.com/raw/gavinbeatty/swaylock-effects/pull/1.patch";
      sha256 = "1m42mb2gawkjf9svbhbdh7r1mfnyy8rxaaw19qns6i428aa4ykzx";
    })
  ];
  mesonFlags = [
    "-Dpam=enabled"
    "-Dgdk-pixbuf=enabled"
    "-Dman-pages=enabled"
  ];

  meta = with lib; {
    description = "Screen locker for Wayland";
    longDescription = ''
      Swaylock, with fancy effects
    '';
    inherit (src.meta) homepage;
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ gnxlxnxx ];
  };
}
