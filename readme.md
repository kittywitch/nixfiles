# nixfiles

## Commands

The commands here aside from the `nix build` command are provided through the shell. The `<target>` and `<host>` commands are runners provided through [arcnmx/tf-nix][].

Please use `nix-shell` or [direnv/direnv][]. The shell is not compatible with [nix-community/nix-direnv][].

| Command                                             | Purpose                                                 |
|-----------------------------------------------------|---------------------------------------------------------|
| `nf-update`                                         | Wraps `nix flake update`.                               |
| `nf-actions`                                        | Updates CI integrations.                                |
| `nf-test`                                           | Tests CI actions.                                       |
| `<target>-apply`                                    | Deploys to the provided target.                         |
| `<target>-tf`                                       | Provides you a terraform shell for the provided target. |
| `<host>-ssh`                                        | SSH into the provided host.                             |
| `nix build -f . network.nodes.<host>.deploy.system` | Build a system closure for the provided host.           |

  [arcnmx/tf-nix]: https://github.com/arcnmx/tf-nix
  [direnv/direnv]: https://github.com/direnv/direnv
  [nix-community/nix-direnv]: https://github.com/nix-community/nix-direnv
