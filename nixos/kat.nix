{ meta, config, pkgs, lib, ... }: with lib;

{
  users.users.kat = {
    uid = 1000;
    isNormalUser = true;
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCocjQqiDIvzq+Qu3jkf7FXw5piwtvZ1Mihw9cVjdVcsra3U2c9WYtYrA3rS50N3p00oUqQm9z1KUrvHzdE+03ZCrvaGdrtYVsaeoCuuvw7qxTQRbItTAEsfRcZLQ5c1v/57HNYNEsjVrt8VukMPRXWgl+lmzh37dd9w45cCY1QPi+JXQQ/4i9Vc3aWSe4X6PHOEMSBHxepnxm5VNHm4PObGcVbjBf0OkunMeztd1YYA9sEPyEK3b8IHxDl34e5t6NDLCIDz0N/UgzCxSxoz+YJ0feQuZtud/YLkuQcMxW2dSGvnJ0nYy7SA5DkW1oqcy6CGDndHl5StOlJ1IF9aGh0gGkx5SRrV7HOGvapR60RphKrR5zQbFFka99kvSQgOZqSB3CGDEQGHv8dXKXIFlzX78jjWDOBT67vA/M9BK9FS2iNnBF5x6shJ9SU5IK4ySxq8qvN7Us8emkN3pyO8yqgsSOzzJT1JmWUAx0tZWG/BwKcFBHfceAPQl6pwxx28TM3BTBRYdzPJLTkAy48y6iXW6UYdfAPlShy79IYjQtEThTuIiEzdzgYdros0x3PDniuAP0KOKMgbikr0gRa6zahPjf0qqBnHeLB6nHAfaVzI0aNbhOg2bdOueE1FX0x48sjKqjOpjlIfq4WeZp9REr2YHEsoLFOBfgId5P3BPtpBQ== yubikey5"
"ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDPsu3vNsvBb/G+wALpstD/DnoRZ3fipAs00jtl8rzDuv96RlS7AJr4aNvG6Pt2D9SYn2wVLaiw+76mz2gOycH9/N+VCvL4/0MN9uqj+7XIcxNRo0gHVOblmi2bOXcmGKh3eRwHj1xyDwRxo9WIuBEP2bPpDPz75OXRtEdlTgvky7siSguQxJu03cb0p9hNAYhUoohNXyWW2CjDCLUQVE1+QRVUzsKq3KkPy0cHYgmZC1gRSMQyKpMt72L5tayLz3Tp/zrshucc+QO5IJeZdqMxsNAcvALsysT1J5EqxZoYH9VpWLRhSgVD6Nvn853pycJAlXQxgOCpSD3/v/JbgUe5NE+ci0o7NMy5IiHUv2gQMRIEhwBHlRGwokUPL9upx0lsjaEiPya5xQqqDKRom87xytM778ANS5CuMdQMWg9qVbpHZUHMjA0QmNkjPgq71pUDXHk5L4mZuS8wVjyjnvlw68yIJuHEc8P7QiLcjvRHFS2L9Ck8NRmPDTQXlQi9kk6LmMyu6fdevR/kZL21b+xO1e2DMyxBbNDTot8luppiiL8adgUDMwptpIne7JCWB1o9NFCbXUVgwuCCYBif6pOGSc6bGo1JTAKMflRlcy6Mi3t5H0mR2lj/sCSTWwTlP5FM4aPIq08NvW6PeuK1bFJY9fIgTwVsUnbAKOhmsMt62w== cardno:12 078 454"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAII74JrgGsDQ6r7tD7+k3ykxXV7DpeeFRscPMxrBsDPhz kat@goliath"
    ];
    shell = pkgs.zsh;
    extraGroups = [ "wheel" "video" "systemd-journal" "plugdev" "bird2" "vfio" "input" "uinput" ];
    hashedPassword = mkIf (meta.trusted ? secrets) (removeSuffix "\n" config.secrets.repo.kat-user.text);
  };

  systemd.tmpfiles.rules = [
    "f /var/lib/systemd/linger/kat"
  ];
}
