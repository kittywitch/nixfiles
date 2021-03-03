{ lib }: 

{
        style = import ./style.nix;
        colorhelpers = import ./colorhelpers.nix { inherit lib; };
}