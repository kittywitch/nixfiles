{ lib
, stdenv
, fetchFromGitHub
}:

stdenv.mkDerivation rec {
  pname = "fusionpbx-apps";
  version = "master";

  src = fetchFromGitHub {
    owner = "fusionpbx";
    repo = pname;
    rev = "c0eb1c852332a8ba3010e54cd1ac634c47f832fb";
    sha256 = "0gqlzzd2m2g2njxqr1kd7bcy3wi4irv7i5njqa8d8iiwwmnvbb4r";
  };

  apps = [
    "active_extensions"
    "backup"
    "bdr"
    "bulk_account_settings"
    "bulk_import_extensions"
    "call_acl"
    "cdr"
    "content"
    "domain_counts"
    "fifo_agents"
    "get_call_details"
    "help"
    "invoices"
    "languages"
    "mobile_twinning"
    "php_service"
    "profiles"
    "roku"
    "schemas"
    "school_bells"
    "servers"
    "services"
    "sessiontalk"
    "sipjs"
    "sipml5"
    "sms"
    "soft_phone"
    "tickets"
    "users_bulk_add"
    "voicemail_msgs"
    "voicemail_status"
    "webrtc"
    "xmpp"
    "zoiper"
  ];

  outputs = lib.singleton "out" ++ apps;

  postPatch = ''
    mv mobile-twinning mobile_twinning
  '';

  installPhase = ''
    mkdir $out
    for app in $apps; do
      mkdir -p ''${!app}/app
      mv $app ''${!app}/app/
      if [[ -d ''${app}/resources/install/scripts/app ]]; then
        mkdir -p ''${!app}/app/scripts/resources/scripts/app
        ln -s ''${!app}/resources/install/scripts/app/* ''${!app}/app/scripts/resources/scripts/app/
      fi
    done
  '';

  meta = with lib; {
    description = "Applications for FusionPBX.";
    homepage = "https://www.fusionpbx.com/";
    license = with licenses; mpl11;
    maintainers = with maintainers; [ kittywitch ];
    platforms = with platforms; unix;
  };
}
