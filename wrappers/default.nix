{
  inputs,
  ...
}@args:
  inputs.utils.lib.eachDefaultSystem (system: let
    newArgs = args // { inherit system; };
  in {
        packages = {
            nf-actions-test = import ./nf-actions-test.nix newArgs;
            nf-generate = import ./nf-generate.nix newArgs;
        };
    })