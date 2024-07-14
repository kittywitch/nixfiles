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
# obtain storepath from nix run github:arcnmx/ci/v0.7 >~<
 nix run --argstr config "./ci/nodes.nix" -f "/nix/store/frf40m951652jv6qqkzfhr6n6r332gk9-source" run.gh-actions-generate --show-trace
```
