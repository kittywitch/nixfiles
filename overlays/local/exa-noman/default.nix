{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, cmake
, pkg-config
, zlib
, installShellFiles
, Security
, libiconv
}:

rustPlatform.buildRustPackage rec {
  pname = "exa";
  version = "0.10.1";

  src = fetchFromGitHub {
    owner = "ogham";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-vChsy/FrJEzTO5O+XFycPMP3jqOeea/hfsC0jJbqUVI=";
  };

  # Cargo.lock is outdated
  cargoPatches = [ ./update-cargo-lock.diff ];

  cargoSha256 = "sha256-ah8IjShmivS6IWL3ku/4/j+WNr/LdUnh1YJnPdaFdcM=";

  nativeBuildInputs = [
    cmake
    pkg-config
    installShellFiles
  ];

  buildInputs = [ zlib ] ++ lib.optionals stdenv.isDarwin [ libiconv Security ];
  outputs = [ "out" ];

  postInstall = ''
    installShellCompletion \
      --name exa completions/completions.bash \
      --name exa.fish completions/completions.fish \
      --name _exa completions/completions.zsh
  '';

  # Some tests fail, but Travis ensures a proper build
  doCheck = false;

  meta = with lib; {
    description = "Replacement for 'ls' written in Rust";
    longDescription = ''
      exa is a modern replacement for ls. It uses colours for information by
      default, helping you distinguish between many types of files, such as
      whether you are the owner, or in the owning group. It also has extra
      features not present in the original ls, such as viewing the Git status
      for a directory, or recursing into directories with a tree view. exa is
      written in Rust, so it’s small, fast, and portable.
    '';
    changelog = "https://github.com/ogham/exa/releases/tag/v${version}";
    homepage = "https://the.exa.website";
    license = licenses.mit;
    maintainers = with maintainers; [ ehegnes lilyball globin fortuneteller2k ];
  };
}
