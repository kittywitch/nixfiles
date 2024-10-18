_: {
    services.postgresql = {
        ensureUsers = [
            {
                name = "matrix-synapse";
                ensureDBOwnership = true;
            }
        ];
        ensureDatabases = [
            "matrix-synapse"
        ];
    };
}