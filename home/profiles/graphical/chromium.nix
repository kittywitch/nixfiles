{ pkgs, ... }: {
    # Backup browser! For aliexpress and things.
    home.packages = [
        pkgs.ungoogled-chromium
    ];
}