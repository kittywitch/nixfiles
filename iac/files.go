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
			Host: pulumi.String(fqdn),
			Port: pulumi.Float64Ptr(float64(port)),
			User: pulumi.String(user),
			// TODO: note to self, write platform support code here. or just expect env var $SSH_AUTH_SOCK?
			AgentSocketPath: pulumi.String("/run/user/1000/gnupg/S.gpg-agent.ssh"), // linux
			//AgentSocketPath: pulumi.String("/Users/kat/.gnupg/S.gpg-agent.ssh"), // darwin
		},
		Triggers: pulumi.All(resources),
		Create:   pulumi.Sprintf("echo \"%s\" > \"/tmp/%s\" && sudo mkdir -p /var/lib/secrets && sudo install --owner=kat --group=users --mode=0600 \"/tmp/%s\" \"/var/lib/secrets/%s\"", value, name, name, name),
		Delete:   pulumi.Sprintf("cd /var/lib/secrets && rm \"%s\"", name),
		Environment: pulumi.StringMap{
			"PULUMI_SKIP_UPDATE_CHECK": pulumi.String("true"),
		},
	}, pulumi.DependsOn(resources), pulumi.IgnoreChanges([]string{})) // within {} put e.g. "create"
}
