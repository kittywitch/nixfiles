package iac

import (
	"crypto/rand"
	"crypto/rsa"
	"fmt"
	tls "github.com/pulumi/pulumi-tls/sdk/v4/go/tls"
	"github.com/pulumi/pulumi/sdk/v3/go/pulumi"
	"golang.org/x/crypto/ssh"
	"time"
)

//  ca_key *tls.PrivateKey,
//  ca_cert *tls.SelfSignedCert) (key *tls.PrivateKey,
// ca_key, ca_cert, err := iac.GenerateTLSCA(ctx)

// parseprivatekey
// newsignerfromkey

func MakeCertificate() ssh.Certificate {
	var newCert ssh.Certificate
	// The sign() method fills in Nonce for us
	newCert.Nonce = make([]byte, 32)
	return newCert
}

func PrivateKeyOpenSSHToRSAPrivateKey(keyPEM string) (key *rsa.PrivateKey, err error) {
	key_int, err := ssh.ParseRawPrivateKey([]byte(keyPEM))
	key_raw := key_int.(*rsa.PrivateKey)
	if err != nil {
		return nil, err
	}
	return key_raw, err
}

func GenerateOpenSSHHost(caKey *tls.PrivateKey, userKey *tls.PrivateKey, keyID string, name string) (certificate pulumi.StringOutput, err error) {
	return GenerateOpenSSH(caKey, userKey, keyID, ssh.HostCert, name)
}

func GenerateOpenSSHUser(caKey *tls.PrivateKey, userKey *tls.PrivateKey, keyID string, name string) (certificate pulumi.StringOutput, err error) {
	return GenerateOpenSSH(caKey, userKey, keyID, ssh.UserCert, name)
}

func GenerateOpenSSH(caKey *tls.PrivateKey, userKey *tls.PrivateKey, keyID string, certType uint32, name string) (certificate pulumi.StringOutput, err error) {
	var caKeyPem *rsa.PrivateKey
	var signer ssh.Signer

	newCert := caKey.PrivateKeyOpenssh.ApplyT(func(capriv string) (cert pulumi.StringOutput) {
		newCertS := userKey.PrivateKeyOpenssh.ApplyT(func(content string) (cert pulumi.String) {
			caKeyPem, err = PrivateKeyOpenSSHToRSAPrivateKey(capriv)
			if err != nil {
				panic(err)
			}
			signer, err = ssh.NewSignerFromKey(caKeyPem)
			if err != nil {
				panic(err)
			}
			newCert := MakeCertificate()
			newCert.CertType = certType
			key, err := PrivateKeyOpenSSHToRSAPrivateKey(content)
			if err != nil {
				panic(err)
			}
			newCert.Key, err = ssh.NewPublicKey(key.Public())
			if err != nil {
				panic(err)
			}
			newCert.Serial = 0
			newCert.KeyId = keyID
			newCert.ValidPrincipals = []string{fmt.Sprintf("%s.inskip.me", name)}
			newCert.ValidAfter = 60
			threemo, err := time.ParseDuration("730h")
			if err != nil {
				panic(err)
			}
			threemosecs := uint64(threemo.Seconds())
			newCert.ValidBefore = threemosecs
			err = newCert.SignCert(rand.Reader, signer)
			return pulumi.String(string(ssh.MarshalAuthorizedKey(&newCert)))
		}).(pulumi.StringOutput)
		if err != nil {
			panic(err)
		}
		return newCertS
	}).(pulumi.StringOutput)

	if err != nil {
		return pulumi.StringOutput{}, err
	}
	return newCert, err
}
