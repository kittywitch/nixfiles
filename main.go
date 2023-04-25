package main

import (
	"github.com/pulumi/pulumi/sdk/v3/go/pulumi"
	"gopkg.in/yaml.v3"
	"kittywitch/iac"
	"os"
)

func main() {
	store := iac.KatConfig{}

	configFile, err := os.ReadFile("config.yaml")

	if err != nil {
		return
	}

	if err := yaml.Unmarshal(configFile, &store); err != nil {
		return
	}

	pulumi.Run(func(ctx *pulumi.Context) error {
		for _, zone := range store.Zones {
			err = zone.Handle(ctx)
			if err != nil {
				return err
			}
			if err != nil {
				return err
			}
		}
		for name, machine := range store.Machines {
			err = machine.Handle(ctx, name)
			if err != nil {
				return err
			}
		}

		err = iac.InskipPage(ctx)
		if err != nil {
			return err
		}
		return err
	})
}
