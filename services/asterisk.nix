{ config, pkgs, witch, ... }:

{
  katnet.public.tcp.ports = [ 5160 5060 ];
  katnet.public.udp.ports = [ 5160 5060 ];

  katnet.public.tcp.ranges = [{
    from = 10000;
    to = 20000;
  }];

  katnet.public.udp.ranges = [{
    from = 10000;
    to = 20000;
  }];

  services.fail2ban.jails = {
    asterisk = ''
      enabled  = true
      filter   = asterisk
      action   = iptables-allports[name=ASTERISK, protocol=all]
      logpath  = /var/log/asterisk/messages
      maxretry = 4
    '';
  };

  services.asterisk = {
    enable = true;
    confFiles = {
      "rtp.conf" = ''
        [general]
        rtpstart=10000
        rtpend=20000
      '';
      "extensions.conf" = ''
        [from-twilio]
        exten => _.,1,Dial(SIP/1337,20)

        [from-signalwire]
        exten => s,1,Set(numb=''${CUT(CUT(PJSIP_HEADER(read,To),@,1),:,2)})
        same  => n,Dial(SIP/1337,20)

        [from-internal]
        exten => _1X.,1,Set(CALLERID(all)="kat" <+${witch.secrets.hosts.athame.phone.number.us}>)
        same  => n,Dial(PJSIP/''${EXTEN:1}@signalwire)
        same  => n(end),Hangup()
        exten => _2X.,1,Set(CALLERID(all)="kat" <+${witch.secrets.hosts.athame.phone.number.canada}>)
        same  => n,Dial(PJSIP/''${EXTEN:1}@signalwire)
        same  => n(end),Hangup()
        exten => _3X.,1,Set(CALLERID(all)="kat" <+${witch.secrets.hosts.athame.phone.number.uk}>)
        same  => n,Dial(PJSIP/+''${EXTEN:1}@twilio-ie)
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
        secret=${witch.secrets.hosts.athame.phone.password}
        nat=force_rport,comedia
      '';
      "pjsip_wizard.conf" = ''
        [user_defaults](!)
        type = wizard
        accepts_registrations = yes
        sends_registrations = no
        accepts_auth = yes
        sends_auth = no
        endpoint/context = from-internal
        endpoint/tos_audio=ef
        endpoint/tos_video=af41
        endpoint/cos_audio=5
        endpoint/cos_video=4
        endpoint/allow = !all,ulaw
        endpoint/dtmf_mode= rfc4733
        endpoint/aggregate_mwi = yes
        endpoint/use_avpf = no
        endpoint/rtcp_mux = no
        endpoint/bundle = no
        endpoint/ice_support = no
        endpoint/media_use_received_transport = no
        endpoint/trust_id_inbound = yes
        endpoint/media_encryption = no
        endpoint/timers = yes
        endpoint/media_encryption_optimistic = no
        endpoint/send_pai = yes
        endpoint/rtp_symmetric = yes
        endpoint/rewrite_contact = yes
        endpoint/force_rport = yes
        endpoint/language = en

        [trunk_defaults](!)
        type = wizard
        endpoint/transport=0.0.0.0-udp
        endpoint/allow = !all,ulaw
        endpoint/t38_udptl=no
        endpoint/t38_udptl_ec=none
        endpoint/fax_detect=no
        endpoint/trust_id_inbound=no
        endpoint/t38_udptl_nat=no
        endpoint/direct_media=no
        endpoint/rewrite_contact=yes
        endpoint/rtp_symmetric=yes
        endpoint/dtmf_mode=rfc4733
        endpoint/allow_subscribe = no
        aor/qualify_frequency = 60

        [twilio-ie](trunk_defaults)
        sends_auth = yes
        sends_registrations = no
        remote_hosts = kat-asterisk.pstn.dublin.twilio.com
        outbound_auth/username = asterisk
        outbound_auth/password = ${witch.secrets.hosts.athame.phone.endpoint.password.twilio}
        endpoint/context = from-twilio
        aor/qualify_frequency = 60
      '';
      "pjsip.conf" = ''
        [global]
        type=global

        [0.0.0.0-udp]
        type=transport
        protocol=udp
        bind=0.0.0.0:5060
        allow_reload=no
        tos=cs3
        cos=3

        [signalwire]
        type=auth
        auth_type=userpass
        username=asterisk ; Your username
        password=${witch.secrets.hosts.athame.phone.endpoint.password.signalwire}

        [signalwire]
        type=aor
        contact=sip:${witch.secrets.hosts.athame.phone.endpoint.url}

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
        from_domain=${witch.secrets.hosts.athame.phone.endpoint.url}
        media_encryption=sdes ; Note that we are using encryption
        context=from-signalwire

        [signalwire]
        type=registration
        server_uri=sip:${witch.secrets.hosts.athame.phone.endpoint.url}
        client_uri=sip:asterisk@${witch.secrets.hosts.athame.phone.endpoint.url}; Your full SIP URI
        outbound_auth=signalwire

        [signalwire]
        type=identify
        endpoint=signalwire
        match=${witch.secrets.hosts.athame.phone.endpoint.url}
      '';
      "logger.conf" = ''
        [general]
        dateformat=%F %T
        [logfiles]
        ; Add debug output to log
        messages => security, notice,warning,error 
        syslog.local0 => notice,warning,error,debug
      '';
    };
  };
}
