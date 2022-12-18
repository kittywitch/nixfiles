{
  inputs = {
    trusted = {
      type = "git";
      url = "gcrypt::ssh://git@github.com/arcnmx/kat-nixfiles-trusted.git";
      ref = "shim";
      flake = false;
    };
    nixfiles = {
      url = "github:kittywitch/nixfiles";
      inputs.trusted.follows = "trusted";
    };
  };
  outputs = { self, trusted, nixfiles, ... }: let
  in nixfiles;
}
