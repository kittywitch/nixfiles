# kittywitch

This project uses:

* Nix
* deploy-rs (without nix flake check malarkey)
* sops-nix
* Terraform Cloud
* and many other things ...

## Usage

```bash
nix shell nixpkgs#repo
nix shell github:kittywitch/kittywitch#repo
direnv allow
sudo nixos-rebuild --flake .#$HOST switch --show-trace
deploy-rs .#$HOST
sops ./systems/yukari.yaml
terraform plan
```