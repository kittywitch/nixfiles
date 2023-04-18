# nixfiles

## Build and Deploy

```shell
:; nf-deploy build
# switch without committing to it...
:; nf-deploy test
:; nf-deploy switch
```

## Editing Secrets

```shell
sops nixos/systems/tewi/secrets.yaml
```
