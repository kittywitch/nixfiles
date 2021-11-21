{
  inputs = {
    trusted = {
      url = "git+ssh://git@github.com/kittywitch/nixfiles-trusted?ref=main";
      flake = false;
    };
    nixfiles = {
      url = "../.";
      inputs.trusted.follows = "trusted";
    };
  };
  outputs = { self, trusted, nixfiles, ... }: let
  in nixfiles;
}
