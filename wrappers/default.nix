{
  inputs,
  ...
}@args: let
in
  inputs.utils.lib.eachDefaultSystem (system: {
        nf-actions-test = import ./nf-actions-test.nix args;
        nf-generate = import ./nf-generate.nix args;
    })