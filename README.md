# kat's nixfiles

To provision a new host:

* create a config for that host that contains a deploy.ssh.host
* run `./nyx install <hostname>`.

To rebuild a host:

* run `./nyx deploy <hostname> <method>` where method is optional, can be... switch or boot or such.
