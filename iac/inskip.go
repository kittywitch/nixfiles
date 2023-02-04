package iac

import (
	"github.com/pulumi/pulumi-cloudflare/sdk/v4/go/cloudflare"
	"github.com/pulumi/pulumi/sdk/v3/go/pulumi"
)

func InskipPage(ctx *pulumi.Context) error {
	_, err := cloudflare.NewPagesProject(ctx, "inskip-root", &cloudflare.PagesProjectArgs{
		AccountId:        pulumi.ID("0467b993b65d8fd4a53fe24ed2fbb2a1"),
		Name:             pulumi.String("inskip-root"),
		ProductionBranch: pulumi.String("main"),
		BuildConfig: &cloudflare.PagesProjectBuildConfigArgs{
			BuildCommand:   pulumi.String("hugo"),
			DestinationDir: pulumi.String("public"),
			RootDir:        pulumi.String("/"),
		},
		Source: &cloudflare.PagesProjectSourceArgs{
			Type: pulumi.String("github"),
			Config: &cloudflare.PagesProjectSourceConfigArgs{
				DeploymentsEnabled: pulumi.Bool(true),
				Owner:              pulumi.String("kittywitch"),
				PrCommentsEnabled:  pulumi.Bool(false),
				PreviewBranchExcludes: pulumi.StringArray{
					pulumi.String("main"),
					pulumi.String("prod"),
				},
				PreviewBranchIncludes: pulumi.StringArray{
					pulumi.String("dev"),
					pulumi.String("preview"),
				},
				PreviewDeploymentSetting:    pulumi.String("custom"),
				ProductionBranch:            pulumi.String("main"),
				ProductionDeploymentEnabled: pulumi.Bool(true),
				RepoName:                    pulumi.String("inskip.me"),
			},
		},
		DeploymentConfigs: &cloudflare.PagesProjectDeploymentConfigsArgs{
			Preview: &cloudflare.PagesProjectDeploymentConfigsPreviewArgs{
				CompatibilityDate:  pulumi.String("2022-08-15"),
				CompatibilityFlags: pulumi.StringArray{},
				/*        D1Databases: pulumi.AnyMap{
				            "D1BINDING": pulumi.Any("445e2955-951a-4358-a35b-a4d0c813f63"),
				          },
				          DurableObjectNamespaces: pulumi.AnyMap{
				            "DOBINDING": pulumi.Any("5eb63bbbe01eeed093cb22bb8f5acdc3"),
				          },
				          EnvironmentVariables: pulumi.AnyMap{
				            "ENVIRONMENT": pulumi.Any("preview"),
				          },
				          KvNamespaces: pulumi.AnyMap{
				            "KVBINDING": pulumi.Any("5eb63bbbe01eeed093cb22bb8f5acdc3"),
				          },
				          R2Buckets: pulumi.AnyMap{
				            "R2BINDING": pulumi.Any("some-bucket"),
				          }, */
			},
			Production: &cloudflare.PagesProjectDeploymentConfigsProductionArgs{
				CompatibilityDate:  pulumi.String("2022-08-16"),
				CompatibilityFlags: pulumi.StringArray{},
				/*D1Databases: pulumi.AnyMap{
				    "D1BINDING1": pulumi.Any("445e2955-951a-4358-a35b-a4d0c813f63"),
				    "D1BINDING2": pulumi.Any("a399414b-c697-409a-a688-377db6433cd9"),
				  },
				  DurableObjectNamespaces: pulumi.AnyMap{
				    "DOBINDING1": pulumi.Any("5eb63bbbe01eeed093cb22bb8f5acdc3"),
				    "DOBINDING2": pulumi.Any("3cdca5f8bb22bc390deee10ebbb36be5"),
				  },
				  EnvironmentVariables: pulumi.AnyMap{
				    "ENVIRONMENT": pulumi.Any("production"),
				    "OTHERVALUE":  pulumi.Any("other value"),
				  },
				  KvNamespaces: pulumi.AnyMap{
				    "KVBINDING1": pulumi.Any("5eb63bbbe01eeed093cb22bb8f5acdc3"),
				    "KVBINDING2": pulumi.Any("3cdca5f8bb22bc390deee10ebbb36be5"),
				  },
				  R2Buckets: pulumi.AnyMap{
				    "R2BINDING1": pulumi.Any("some-bucket"),
				    "R2BINDING2": pulumi.Any("other-bucket"),
				  },*/
			},
		},
	})
	_, err = cloudflare.NewPagesDomain(ctx, "inskip-root", &cloudflare.PagesDomainArgs{
		AccountId:   pulumi.String("0467b993b65d8fd4a53fe24ed2fbb2a1"),
		Domain:      pulumi.String("inskip.me"),
		ProjectName: pulumi.String("inskip-root"),
	})
	if err != nil {
		return err
	}
	return nil
}
