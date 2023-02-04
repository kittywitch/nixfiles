package iac

type KatConfig struct {
	Zones map[string]Zone `yaml:"zones"`
}
