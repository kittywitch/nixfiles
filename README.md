# kat's nixfiles

To provision a new host:

* add that host to the SSH config in programs.ssh
* create a config for that host that contains a meta.deploy.ssh.host
* run `./nyx install <hostname>`.

To rebuild a host:

* run `,/nyx build <hostname> <method>` where method is optional, can be... switch or boot or such.
