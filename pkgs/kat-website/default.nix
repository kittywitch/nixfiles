{ fetchgit, stdenv, lib, bundler, ruby, bundlerEnv }:

stdenv.mkDerivation rec {
  pname = "kat-website";
  version = "0.1";

  src = fetchgit {
    rev = "5d7d5b57df1edfddbdbf871db3fbc9400a94fc19";
    url = "https://git.kittywit.ch/kat/website.git";
    sha256 = "1d7dva1iz99bg9fqhqqjdqqmmi6w0ybmgjkhq8xx193bc620xg0a";
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

