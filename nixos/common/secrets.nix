_: {
    users.groups.secrets = {};
    systemd.tmpfiles.rules = [
        "v /var/lib/secrets 700 deploy secrets"
    ];
}