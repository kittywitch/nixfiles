package iac

import (
  "github.com/pulumi/pulumi-command/sdk/go/command/local"
  "github.com/pulumi/pulumi/sdk/v3/go/pulumi"
  "github.com/pulumi/pulumi-tls/sdk/v4/go/tls"
  "fmt"
  "os"
  "path"
)

func createPulumiFile(ctx *pulumi.Context, name string, value pulumi.StringOutput, resource pulumi.Resource) (*local.Command, error) {
  repo_root := os.Getenv("REPO_ROOT")
  data_root := path.Join(repo_root, "./data")
  ctx.Export(name, value)
  return local.NewCommand(ctx, name, &local.CommandArgs{
    Create: pulumi.String(fmt.Sprintf("pulumi stack output %s --non-interactive --show-secrets > %s", name, name)),
    Update: pulumi.String(fmt.Sprintf("pulumi stack output %s --non-interactive --show-secrets > %s", name, name)),
    Delete: pulumi.String(fmt.Sprintf("rm %s", name)),
    Dir: pulumi.String(data_root),
    Environment: goMapToPulumiMap(map[string]string{
      "PULUMI_SKIP_UPDATE_CHECK": "true",
    }),
  }, pulumi.DependsOn([]pulumi.Resource{resource}))
}

func PKITLSFiles(ctx *pulumi.Context, files_ map[string]*local.Command, keys map[string]*tls.PrivateKey, certs map[string]*tls.LocallySignedCert) (files map[string]*local.Command, err error) {
  for name_, key := range keys {
    name := fmt.Sprintf("%s-file", name_)
    files_[name], err = createPulumiFile(ctx, name, key.PrivateKeyPem, key)
    if err != nil {
      return nil, err
    }
  }
  for name_, cert := range certs {
    name := fmt.Sprintf("%s-file", name_)
    files_[name], err = createPulumiFile(ctx, name, cert.CertPem, cert)
    if err != nil {
      return nil, err
    }
  }
  return files_, err
}
