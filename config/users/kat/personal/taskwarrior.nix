{ config, pkgs, tf, lib, ... }:

{
  kw.secrets = [ "taskwarrior-key" "taskwarrior-creds" ];

  secrets.files = {
    taskw_key = {
      text = "${tf.variables.taskwarrior-key.ref}";
      owner = "kat";
      group = "users";
    };
    taskw_config = {
      text = ''
        taskd.credentials=${tf.variables.taskwarrior-creds.ref}
      '';
      owner = "kat";
      group = "users";
    };
  };

  programs.taskwarrior = {
    enable = true;
    config = {
      taskd = {
        certificate = "${pkgs.writeText "taskd_cert.pem" ''
            -----BEGIN CERTIFICATE-----
            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
            kuLR6WeghnkGENo=
            -----END CERTIFICATE-----
        ''}";
        key = config.secrets.files.taskw_key.path;
        ca = "${pkgs.writeText "taskd_ca.pem" ''
            -----BEGIN CERTIFICATE-----
            MIIE/zCCAuegAwIBAgIUO/FZVcMIwnusVeiMGNOHznpUH7UwDQYJKoZIhvcNAQEM
            BQAwFjEUMBIGA1UEAxMLa2l0dHl3aXQuY2gwIBcNMjEwMzE0MDA1MjUwWhgPOTk5
            OTEyMzEyMzU5NTlaMBYxFDASBgNVBAMTC2tpdHR5d2l0LmNoMIICIjANBgkqhkiG
            9w0BAQEFAAOCAg8AMIICCgKCAgEA1ui/3U5yhyd2J2Z1ahq6uMyS8HHpuX8TSxNV
            mbNPTc1D+jGHa3W7sp0GHRDM6Ct9A0BJkkWAjegWJBZRXAeryZg++xoPma4AK908
            /8uq1WTgchy74Or6luTFKHhxkNXZcjNCjsVGeaogK1KvBLapP83L8mBVb1n5DjlN
            I4XhREe4kTWhMJuoG1yUca3g2iIezKa+b1GYY/jOpEOQiciqxjcwgSZSpRTH2kC9
            3d9JFzJBU+kTDVjuaC3SWgu9tqk2WiBRr3ERUdBvEIRq90xax1ChSAEZgrb3k3yS
            vE5IsZ3F85piDbS7tBh6PgbaWf9Bxp4rVJ6FeypSNFyBwzgQP3jiKLJcgChjFIDx
            imkJmdQJEmSNImgofkO5l3ZYwXal4G1qT1na+ashrQAbYdDdbgg0XDctVKQBY6oP
            YSbyp1aJTed7I2Tm9xm/pSFwR5JrWv7qMB8/4XwziraRL13KGoCmWcfqcUWm6hKW
            cTnaA6J5gbNQC3R0+yJXZE+lrUL2QBkM7QtLRHB8FIBQcwKxLmEIB702B+X41EAL
            2gmzV8PpoQvUDQ8w0jZ3HB0f7R5MTYhv44qF4KM30i6gdUPFeiy6lnaqs17yfu8x
            kNm2SD7NwmSrDUpAnmvuq7Iq7xvkdr0+qi2p7N7RolJOHw9jYJnU9YXj6CDS2ofg
            ur+eWBsCAwEAAaNDMEEwDwYDVR0TAQH/BAUwAwEB/zAPBgNVHQ8BAf8EBQMDBwQA
            MB0GA1UdDgQWBBRmz2varlp5iPH6DGESWjtTVUs3jjANBgkqhkiG9w0BAQwFAAOC
            AgEAATViuvVGa1p5CBTghmp51VfMOcQoAOiTe+tIOVJMRc379uPfESMJ5nsVlZCt
            rP+XhDA6gGToEjcUBZIwfLzrKSmbmTpmVK+X5EMGldbytBkdbhQkUaLqD3LnxNNr
            WnwhHKcMKAJlZ/523AjFURA3cGf7anhghJHJbr3En45jfrYabKX9gpBpmnOVrBNG
            cd5ZmwLMJKrASQ14Px+XHX7+S5y6D2dM6qvXG4y6YMwlROqoy3gcG7j+uvdCzWuC
            sSpOj0gVOcCdeOZuSD0lFXbh4WnrS2SDG6M2Zj2tLRsn8nq76RqxIKz9dWSV7nXM
            xTSSZOs01rvyrwd1Ydez+qYg5db0ZcD4mF2b78QJU8gKevh53UvHv1PK8I1S6+1E
            i5qnduRrX8FaKcD0+UkvLG9ZeE855K1cnquy9vAiuHgKp90R+yzyQfj7w1ofigCR
            YSADxgw7w/s5OBIeUYw43SmkmL5nLCAETm36mr2l1g6ixtjN3qDJXnGWHvAHUdhY
            4vhBNNwEtvLp73skkmj5+5qaxn5e8jR9WoNxr8ajoRFaH6LlpoI4/+fWhmfTCpXj
            UkdGJClj76VuB1PAg0xCnuLDT2xCA6leF07bn+P8Xzhh21AR1oq2eTyUGkgA2oqi
            kmKyccoP1SQXAZd96EFArlzalVt+h+fOuOxuulmqVskK+w0=
            -----END CERTIFICATE-----
        ''}";
        server = "${config.network.dns.domain}:53589";
      };
    };
    extraConfig = ''
      include ${config.secrets.files.taskw_config.path}
    '';
  };
}
