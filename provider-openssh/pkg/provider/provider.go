package provider

import (
	"crypto"
	"crypto/ed25519"
	"crypto/rand"
	"crypto/rsa"
	"strings"
	"time"

	"github.com/blang/semver"
	p "github.com/pulumi/pulumi-go-provider"
	"github.com/pulumi/pulumi-go-provider/infer"
	"github.com/pulumi/pulumi-go-provider/integration"
	"github.com/pulumi/pulumi-go-provider/middleware/schema"
	"github.com/pulumi/pulumi/sdk/v3/go/common/tokens"
	"golang.org/x/crypto/ssh"
)

func Provider() p.Provider {
	return infer.Provider(infer.Options{
		Metadata: schema.Metadata{
			DisplayName: "OpenSSH Cert",
			Description: "I hope the people who worked on pulumi stub their toe every day",
			Keywords: []string{
				"pulumi",
				"openssh",
				"category/utility",
				"kind/native",
			},
			Homepage:   "https://kittywit.ch",
			License:    "WTFPL",
			Repository: "https://github.com/kittywitch/kittywitch",
			Publisher:  "Pulumi",
			LogoURL:    "https://raw.githubusercontent.com/pulumi/pulumi-command/master/assets/logo.svg",
			// This contains language specific details for generating the provider's SDKs
			LanguageMap: map[string]any{
				"go": map[string]any{
					"generateResourceContainerTypes": true,
					"importBasePath":                 "github.com/kittywitch/provider-opensshcertificate/sdk/go/provider",
				},
			},
		},
		Resources: []infer.InferredResource{infer.Resource[*OpenSSHCertificate, OpenSSHCertificateArgs, OpenSSHCertificateState]()},
		ModuleMap: map[tokens.ModuleName]tokens.ModuleName{
			"opensshcertificate": "index",
		},
	})
}

type OpenSSHCertificate struct{}

type OpenSSHCertificateArgs struct {
	Algorithm      string `pulumi:"algorithm"`
	Kind           string `pulumi:"kind"`
	Hostname       string `pulumi:"hostname"`
	CAPrivateKey   string `pulumi:"cakey"`
	UserPrivateKey string `pulumi:"userkey"`
	Duration       string `pulumi:"duration"`
}
type OpenSSHCertificateState struct {
	OpenSSHCertificateArgs
	Content string `pulumi:"content"`
}

func (c *OpenSSHCertificate) Create(ctx p.Context, name string, input OpenSSHCertificateArgs, preview bool) (string, OpenSSHCertificateState, error) {
	state := OpenSSHCertificateState{OpenSSHCertificateArgs: input}
	if preview {
		return name, state, nil
	}
	caPrivateKeyInterface, err := ssh.ParseRawPrivateKey([]byte(input.CAPrivateKey))
	if err != nil {
		return name, state, err
	}
	userPrivateKeyInterface, err := ssh.ParseRawPrivateKey([]byte(input.UserPrivateKey))
	if err != nil {
		return name, state, err
	}
	var signer ssh.Signer
	var userPublicKey crypto.PublicKey
	caPrivateKey := caPrivateKeyInterface.(*rsa.PrivateKey)
	switch input.Algorithm {
	case "rsa":
		userPrivateKey := userPrivateKeyInterface.(*rsa.PrivateKey)
		userPublicKey = userPrivateKey.Public()
		signer, err = ssh.NewSignerFromKey(caPrivateKey)
	case "ed25519":
		userPrivateKey := userPrivateKeyInterface.(*ed25519.PrivateKey)
		userPublicKey = userPrivateKey.Public()
		signer, err = ssh.NewSignerFromKey(caPrivateKey)
	default:
		panic("unsupported key algorithm")
	}
	if err != nil {
		return name, state, err
	}
	var cert ssh.Certificate
	switch input.Kind {
	case "user":
		cert.CertType = ssh.UserCert
	case "host":
		cert.CertType = ssh.HostCert
	default:
		panic("unsupported key kind")
	}
	cert.Key, err = ssh.NewPublicKey(userPublicKey)
	if err != nil {
		panic(err)
	}
	now := time.Now()
	nowunix := uint64(now.Unix())
	cert.Serial = nowunix
	cert.KeyId = input.Hostname
	cert.ValidPrincipals = []string{input.Hostname}
	cert.ValidAfter = nowunix
	duration, err := time.ParseDuration(input.Duration)
	if err != nil {
		panic(err)
	}
	cert.ValidBefore = uint64(now.Add(duration).Unix())
	err = cert.SignCert(rand.Reader, signer)
	state.Content = string(ssh.MarshalAuthorizedKey(&cert))
	return name, state, nil
}

func Schema(version string) (string, error) {
	if strings.HasPrefix(version, "v") {
		version = version[1:]
	}
	s, err := integration.NewServer("opensshcertificate", semver.MustParse(version), Provider()).
		GetSchema(p.GetSchemaRequest{})
	return s.Schema, err
}
