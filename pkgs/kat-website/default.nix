{ fetchgit, stdenv, lib, bundler, ruby, bundlerEnv }:

stdenv.mkDerivation rec {
  pname = "kat-website";
  version = "0.1";

  src = fetchgit {
    rev = "6fb22229e4d92bdbc720e40525704e1cbf6055a1";
    url = "https://github.com/kittywitch/website";
    sha256 = "1psx2svxbkprjqrk0nqj4xi1q4q51kbagg6w1wl8wwf0dnghxdfr";
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

