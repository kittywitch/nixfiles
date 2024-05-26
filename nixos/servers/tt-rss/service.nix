{ pkgs, ... }: {
    services.tt-rss = {
        enable = true;
        virtualHost = "rss.kittywit.ch";
        selfUrlPath = "https://rss.kittywit.ch";
        database = {
            type = "pgsql";
            host = null;
            name = "tt_rss";
            createLocally = false;
        };
        plugins = [
          "auth_internal"
          "auth_ldap"
          "note"
          "updater"
          "api_feedreader"
        ];
    };
}