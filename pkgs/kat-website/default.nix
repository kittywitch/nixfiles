{ fetchgit, stdenv, lib, bundler, ruby, bundlerEnv }:

stdenv.mkDerivation rec {
  pname = "kat-website";
  version = "0.1";

  src = fetchgit {
    rev = "9d4344c8c38a932178d6b3ee78a6a43048f2c27f";
    url = "https://git.kittywit.ch/kat/website.git";
    sha256 = "1z4r6gp2k4qxgmbhx6vivdfggsimri98nda9yybgxbxbiyy2w9jn";
  };

  jekyll_env = bundlerEnv rec {
    name = "jekyll_env";
    inherit ruby;
    gemfile = "${src}/Gemfile";
    lockfile = "${src}/Gemfile.lock";
    gemset = ./gemset.nix;
  };

  buildInputs = [
    bundler
    ruby
    jekyll_env
  ];

  installPhase = ''
      mkdir $out
      ${jekyll_env}/bin/jekyll build -d $out
  '';
}

