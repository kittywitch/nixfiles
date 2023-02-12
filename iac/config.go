package iac

type KatConfig struct {
	Zones    map[string]Zone    `yaml:"zones"`
	Machines map[string]Machine `yaml:"machines"`
}
