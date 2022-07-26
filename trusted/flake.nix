{
  inputs = {
    trusted = {
      url = "git+ssh://git@github.com/kittywitch/nixfiles-trusted?ref=main";
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
