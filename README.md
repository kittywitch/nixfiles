# kittywitch infrastructure

This repository is my personal infrastructure repository. It contains the Nix and Terraform I leverage.

## Structure

| Path           | Purpose                                                                                           |
| -------------- | ------------------------------------------------------------------------------------------------- |
| common/        | Common imports to NixOS and macOS systems                                                         |
| darwin/        | macOS (nix-darwin) related configuration                                                          |
| darwin/common  | Imported into all nix-darwin systems                                                              |
| kat            | Configurations relevant to my use of a computer, including base16 + vscodium                      |
| kat/common     | Disables manuals                                                                                  |
| kat/gnome      | GNOME. Including dconf configuration.                                                             |
| kat/gui        | Packages I use on a host that has a WM / DE.                                                      |
| kat/neovim     | Text editor of choice, though VSCode or a JetBrains IDE normally takes forefront for development. |
| kat/shell      | My shell configs. I use zsh, fzf, z, starship, exa, rg, fd, sd, ...                               |
| kat/sway       | My tiling window manager of choice (though I'll happily take i3 too)                              |
| kat/user       | Per-system type configurations. Data on my user.                                                  |
| modules/nixos  | An area for more reusable NixOS modules                                                           |
| modules/darwin | An area for more reusable nix-darwin modules                                                      |
| modules/home   | An area for more reusable home-manager modules                                                    |
| nixos/         | NixOS related configuration                                                                       |
| nixos/common   | Imported into all NixOS systems                                                                   |
| nixos/hardware | Per-machine hardware configuration                                                                |
| nixos/roles    | Roles / services / ...                                                                            |
| packages/      | Package overlay                                                                                   |
| shells/        | nix develop shells / devShells                                                                    |
| systems/       | A collection of NixOS hosts and a nix-darwin host.                                                |
| tf/            | Terraform!                                                                                        |
| .envrc         | direnv config                                                                                     |
| .sops.yaml     | Secrets (user & hosts) config                                                                     |
| default.nix    | flake-compat                                                                                      |
| flake.nix      | flake inputs                                                                                      |
| formatter.nix  | flake formatter of choice                                                                         |
| outputs.nix    | flake outputs                                                                                     |
| overlays.nix   | nixpkgs overlays                                                                                  |
| pkgs.nix       | nixpkgs config                                                                                    |
| std.nix        | Overlay to [nix-std](https://github.com/chessai/nix-std)                                          |
| tree.nix       | The configuration system used by my import handler, [tree](https://github.com/kittywitch/tree)    |

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
terraform plan
```


## To-dos

- [ ] Figure out roles/ vs profiles more.
