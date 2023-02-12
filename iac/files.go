package iac

import (
	"github.com/pulumi/pulumi-command/sdk/go/command/remote"
	"github.com/pulumi/pulumi/sdk/v3/go/pulumi"
)

func CreatePulumiFile(ctx *pulumi.Context, name string, fqdn string, value pulumi.StringOutput, resources []pulumi.Resource) (*remote.Command, error) {
	port := 22
	user := "deploy"
	if fqdn == "tewi.inskip.me" {
		port = 62954
		user = "root"
	}
	ctx.Export(name, value)
	return remote.NewCommand(ctx, name, &remote.CommandArgs{
		Connection: &remote.ConnectionArgs{
			Host:            pulumi.String(fqdn),
			Port:            pulumi.Float64Ptr(float64(port)),
			User:            pulumi.String(user),
			AgentSocketPath: pulumi.String("/Users/kat/.gnupg/S.gpg-agent.ssh"),
		},
		Triggers: pulumi.All(resources),
		Create:   pulumi.Sprintf("sudo mkdir -p /var/lib/secrets && echo \"%s\" | sudo tee \"/var/lib/secrets/%s\"", value, name),
		Delete:   pulumi.Sprintf("cd /var/lib/secrets && rm %s", name),
		Environment: pulumi.StringMap{
			"PULUMI_SKIP_UPDATE_CHECK": pulumi.String("true"),
		},
	}, pulumi.DependsOn(resources), pulumi.IgnoreChanges([]string{"create"}))
}
