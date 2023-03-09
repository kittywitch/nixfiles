package main

import (
	"fmt"
	"os"

	meow "github.com/kittywitch/provider-opensshcertificate/pkg/provider"
	p "github.com/pulumi/pulumi-go-provider"
)

func main() {
	err := p.RunProvider("opensshcertificate", "0.1.0", meow.Provider())
	if err != nil {
		fmt.Fprintf(os.Stderr, "Error: %s", err.Error())
		os.Exit(1)
	}
}
