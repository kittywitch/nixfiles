# Proto readme

* export NIX_SSHOPTS="-p 62954"
* export NIX_SSHOPTS="-p 22"
* nix build -f . deploy.all && ./result
* nix build -f . deploy.$group && ./result
* nix build -f . deploy.$hostname && ./result
