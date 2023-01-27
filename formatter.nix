{
  inputs,
  pkgs,
  ...
}:
inputs.utils.lib.eachDefaultSystem (system: {
  ${system} = pkgs.${system}.alejandra;
})
