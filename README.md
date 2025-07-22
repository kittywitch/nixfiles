# kittywitch infrastructure

This repository is my personal infrastructure repository. It contains the Nix and Terraform I leverage.

## Usage

```bash
# get the repo shell
nix develop .#repo

# get the repo shell from outside of the repo
nix develop github:kittywitch/kittywitch#repo

# use direnv to get the repo shell
direnv allow

# repl
nix repl .
nix repl
:lf .

# deploy locally
sudo nixos-rebuild --flake .#$HOST switch --show-trace

# deploy with deploy-rs (without checks)
deploy-rs -s .#$HOST

# edit a secret file
sops ./systems/yukari.yaml

# output a secret file
sops -d ./systems/yukari.yaml

# plan an apply
cd tf/
terraform plan

# update nodes CI
CI_PLATFORM=impure nix run -f https://github.com/arcnmx/ci/archive/v0.7.tar.gz run.gh-actions-generate --arg config ./ci/nodes.nix
```
