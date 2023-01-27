package iac

import (
  "github.com/pulumi/pulumi/sdk/v3/go/pulumi"
)

func goStringArrayToPulumiStringArray(ss []string) pulumi.StringArray {
  var elems []pulumi.StringInput
  for _, s := range ss {
    elems = append(elems, pulumi.String(s))
  }
  return pulumi.StringArray(elems)
}

func goMapToPulumiMap(m map[string]string) pulumi.StringMap {
  ret := make(pulumi.StringMap)
  for k, v := range m {
    ret[k] = pulumi.String(v)
  }
  return ret
}
