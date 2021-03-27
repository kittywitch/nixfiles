{ fetchgit, stdenv, lib, bundler, ruby, bundlerEnv }:

stdenv.mkDerivation rec {
  pname = "kat-website";
  version = "0.1";

  src = fetchgit {
    rev = "273fee9865c99ecce555828bf874d938620650ac";
    url = "https://git.kittywit.ch/kat/website.git";
    sha256 = "0f2kk7adl5haqr0fimk3w5ayf8lh754dwnkwjrx967f6z18bwmdq";
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

