{ config, pkgs, ... }:

let secrets = (import ../../../secrets.nix);
in {
  services.asterisk = {
    enable = true;
    confFiles = {
      "rtp.conf" = ''
        [general]
        rtpstart=10000
        rtpend=20000
      '';
      "extensions.conf" = ''
        [outbound]
        exten => _1NXXNXXXXXX,1,Dial(PJSIP/''${EXTEN}@signalwire)

        [from-signalwire]
        exten => s,1,Set(numb=''${CUT(CUT(PJSIP_HEADER(read,To),@,1),:,2)})
        same  => n,Dial(SIP/1337,20)

        [from-internal]
        exten => _1X.,1,Set(CALLERID(all)="kat" <+${secrets.hosts.athame.phone.number.us}>)
        same  => n,Dial(PJSIP/''${EXTEN:1}@signalwire)
        same  => n(end),Hangup()
        exten => _2X.,1,Set(CALLERID(all)="kat" <+${secrets.hosts.athame.phone.number.canada}>)
        same  => n,Dial(PJSIP/''${EXTEN:1}@signalwire)
        same  => n(end),Hangup()
      '';
      "pjproject.conf" = ''
        ; Common pjproject options
        ;

        ;========================LOG_MAPPINGS SECTION OPTIONS===============================
        ;[log_mappings]
        ;  SYNOPSIS: Provides pjproject to Asterisk log level mappings.
        ;  NOTES: The name of this section in the pjproject.conf configuration file must
        ;         remain log_mappings or the configuration will not be applied.
        ;         The defaults mentioned below only apply if this file or the 'log_mappings'
        ;         object can'tbe found.  If the object is found, there are no defaults. If
        ;         you don't specify an entry, nothing will be logged for that level.
        ;
        ;asterisk_error =    ; A comma separated list of pjproject log levels to map to
                            ; Asterisk errors.
                            ; (default: "0,1")
        ;asterisk_warning =  ; A comma separated list of pjproject log levels to map to
                            ; Asterisk warnings.
                            ; (default: "2")
        ;asterisk_notice =   ; A comma separated list of pjproject log levels to map to
                            ; Asterisk notices.
                            ; (default: "")
        ;asterisk_verbose =  ; A comma separated list of pjproject log levels to map to
                            ; Asterisk verbose.
                            ; (default: "")
        ;asterisk_debug =    ; A comma separated list of pjproject log levels to map to
                            ; Asterisk debug
                            ; (default: "3,4,5")
        ;type=               ; Must be of type log_mappings (default: "")

      '';
      "sip.conf" = ''
        [general]
        ;; Only uncomment this if you want to connect to a different SIP server and receive calls from it
        context=public
        allowguest=no
        udpbindaddr=0.0.0.0:5160
        tcpbindaddr=0.0.0.0:5160
        tcpenable=yes
        transport=udp,tcp
        disallow=all
        allow=speex32
        allow=g722
        allow=ulaw
        allow=alaw
        allow=gsm
        allow=g726

        [1337]
        type=friend
        context=from-internal
        host=dynamic
        secret=${secrets.hosts.athame.phone.password}
        nat=force_rport,comedia
      '';
      "pjsip.conf" = ''
        [transport-udp]
        type=transport
        protocol=udp
        bind=0.0.0.0

        [signalwire]
        type=auth
        auth_type=userpass
        username=asterisk ; Your username
        password=${secrets.hosts.athame.phone.endpoint.password}

        [signalwire]
        type=aor
        contact=sip:${secrets.hosts.athame.phone.endpoint.url}

        [signalwire]
        type=endpoint
        transport=transport-udp
        outbound_auth=signalwire ; Note that there is only an outbound_auth, as we do not challenge when a call arrives inbound
        aors=signalwire
        disallow=all
        allow=speex32
        allow=g722
        allow=ulaw
        allow=alaw
        allow=gsm
        allow=g726
        from_user=asterisk
        from_domain=${secrets.hosts.athame.phone.endpoint.url}
        media_encryption=sdes ; Note that we are using encryption
        context=from-signalwire

        [signalwire]
        type=registration
        server_uri=sip:${secrets.hosts.athame.phone.endpoint.url}
        client_uri=sip:asterisk@${secrets.hosts.athame.phone.endpoint.url}; Your full SIP URI
        outbound_auth=signalwire

        [signalwire]
        type=identify
        endpoint=signalwire
        match=${secrets.hosts.athame.phone.endpoint.url}
      '';
      "logger.conf" = ''
        [general]
        [logfiles]
        ; Add debug output to log
        syslog.local0 => notice,warning,error,debug
      '';
    };
  };
}
