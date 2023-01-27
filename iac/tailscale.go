package iac

import (
  "github.com/pulumi/pulumi/sdk/v3/go/pulumi"
  tailscale "github.com/pulumi/pulumi-tailscale/sdk/go/tailscale"
  cloudflare "github.com/pulumi/pulumi-cloudflare/sdk/v4/go/cloudflare"
  tls "github.com/pulumi/pulumi-tls/sdk/v4/go/tls"
  "strings"
  "net"
  "fmt"
)

func MakeRecord(ctx *pulumi.Context, zones map[string]*cloudflare.Zone, name string, address string) (record *cloudflare.Record, err error) {
  ip := net.ParseIP(address)
  kind := A;
  if ip.To4() != nil {
    kind = AAAA;
  }
  record_ := DNSRecord{
    Name: name,
    Kind: kind,
    Value: ip.String(),
    Ttl: 3600,
  }
  record, err = record_.handle(ctx, "inskip", zones["inskip"])
  if err != nil {
    return nil, err
  }
  return record, err
}

func HandleTSRecord(ctx *pulumi.Context, zones map[string]*cloudflare.Zone, device tailscale.GetDevicesDevice) (records []*cloudflare.Record, err error) {
  if device.User != "kat@inskip.me" {
    return []*cloudflare.Record{}, nil
  }
  name := strings.Split(device.Name, ".")[0]
  for _, address := range device.Addresses {
    record, err := MakeRecord(ctx, zones, name, address)
    if err != nil {
      return nil, err
    }
    records = append(records, record)
  }
  return records, err
}

func HandleTSRecords(ctx *pulumi.Context,
  tailnet *tailscale.GetDevicesResult,
  zones map[string]*cloudflare.Zone,
  records map[string][]*cloudflare.Record,
) (records_ map[string][]*cloudflare.Record, err error) {
  for _, device := range tailnet.Devices {
    record, err := HandleTSRecord(ctx, zones, device)
    if err != nil {
      return nil, err
    }
    records["inskip"] = append(records["inskip"], record...)
  }
  records_ = records
  return records_, err
}

func HandleTSHostCert(ctx *pulumi.Context,
  device tailscale.GetDevicesDevice,
  ca_key *tls.PrivateKey,
  ca_cert *tls.SelfSignedCert) (key *tls.PrivateKey,
  cr *tls.CertRequest,
  cert *tls.LocallySignedCert,
  err error) {
  name := strings.Split(device.Name, ".")[0]
  key, cr, cert, err = generateKeyPair(
    ctx,
    fmt.Sprintf("ts-%s-host", name),
    ca_key,
    ca_cert,
    device.Addresses,
    []string{fmt.Sprintf("%s.inskip.me", name)},
  )
  if err != nil {
    return nil, nil, nil, err
  }
  return key, cr, cert, err
}

func HandleTSHostCerts(ctx *pulumi.Context,
  tailnet *tailscale.GetDevicesResult,
  ca_key *tls.PrivateKey,
  ca_cert *tls.SelfSignedCert) (keys map[string]*tls.PrivateKey,
  crs map[string]*tls.CertRequest,
  certs map[string]*tls.LocallySignedCert,
  err error) {
  keys = make(map[string]*tls.PrivateKey)
  crs = make(map[string]*tls.CertRequest)
  certs = make(map[string]*tls.LocallySignedCert)

  for _, device := range tailnet.Devices {
    name := strings.Split(device.Name, ".")[0]
    keys[name], crs[name], certs[name], err = HandleTSHostCert(ctx, device, ca_key, ca_cert)
    if err != nil {
      return nil, nil, nil, err
    }
  }
  return keys, crs, certs, err
}
