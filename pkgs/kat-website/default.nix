{ fetchgit, stdenv, lib, bundler, ruby, bundlerEnv }:

stdenv.mkDerivation rec {
  pname = "kat-website";
  version = "0.1";

  src = fetchgit {
    rev = "22ed32f62d48d432b40cc69408a912848c26972b";
    url = "https://github.com/kittywitch/website";
    sha256 = "0rp26axwcsqs1xid6abf2ai8zncj494w402r4vncn9zg4rkrzq44";
  };

  jekyll_env = bundlerEnv rec {
    name = "jekyll_env";
    inherit ruby;
    gemfile = "${src}/Gemfile";
    lockfile = "${src}/Gemfile.lock";
    gemset = ./gemset.nix;
  };

  buildInputs = [ bundler ruby jekyll_env ];

  installPhase = ''
    mkdir $out
    ${jekyll_env}/bin/jekyll build -d $out
  '';
}

