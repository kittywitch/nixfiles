{ fetchgit, stdenv, lib, bundler, ruby, bundlerEnv }:

stdenv.mkDerivation rec {
  pname = "kat-website";
  version = "0.1";

  src = fetchgit {
    rev = "63dd63d6630a3cd6367ab526d2caa1029b6f2101";
    url = "https://github.com/kittywitch/website";
    sha256 = "0igiljsfxlmmpz63naydnmbyq5kx9jvw39lk5rqdg9091ysjg01l";
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

