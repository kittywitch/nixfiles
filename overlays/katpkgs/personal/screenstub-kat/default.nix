{ fetchFromGitHub, rustPlatform, pkg-config, lib, libxcb, udev, python3 }:

rustPlatform.buildRustPackage rec {
  pname = "screenstub";
  version = "2021-01-08";
  src = fetchFromGitHub {
    owner = "arcnmx";
    repo = pname;
    rev = "e379279fedaaa1d06b1d89da4cf54752814a456f";
    sha256 = "0qv15rpazrpdspfcvyizbjdrrm2nrqz0790pa8zvp5bjsw4mvwvx";
  };

  patches = [ ./main.patch ];

  nativeBuildInputs = [ pkg-config python3 ];
  buildInputs = [ libxcb udev ];

  cargoSha256 = "1m85lisy0085z4lr27lw0b9kbf134qz8dkjvcjnkwxgikx60pq3i";

  doCheck = false;
}
