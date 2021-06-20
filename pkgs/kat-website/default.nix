{ fetchgit, stdenv, lib, bundler, ruby, bundlerEnv }:

stdenv.mkDerivation rec {
  pname = "kat-website";
  version = "0.1";

  src = fetchgit {
    rev = "44f14c6fc24e2f9155d704f5fb3e5dfef18841bd";
    url = "https://github.com/kittywitch/website";
    sha256 = "1w4spn1bdlvhknhrjcpr6g4q39wm03nfv128k33hvbmc3y23rysy";
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

