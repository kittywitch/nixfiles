_: let
  hostConfig = {
    lib,
    tree,
    inputs,
    ...
  }:
  let
   inherit (lib.modules) mkForce;
  in {
    imports = with tree; [
      inputs.wsl.nixosModules.wsl
      kat.gui
      nixos.gui.fonts
      nixos.gui.gpg
    ];

    programs.dconf.enable = true;

    networking.firewall.enable = mkForce false;

    boot.kernel.sysctl = mkForce {};

    systemd.services = {
      systemd-sysctl.enable = false;
    };

    fileSystems = {
      "/" = {
        device = "/dev/sdc";
        fsType = "ext4";
      };
      "/usr/lib/wsl/drivers" = {
        device = "drivers";
        fsType = "9p";
      };
      "/usr/lib/wsl/lib" = {
        device = "none";
        fsType = "overlay";
      };
      "/mnt/wsl" = {
        device = "none";
        fsType = "tmpfs";
      };
      "/mnt/wslg" = {
        device = "none";
        fsType = "tmpfs";
      };
      "/mnt/wslg/doc" = {
        device = "none";
        fsType = "overlay";
      };
      "/mnt/c" = {
        device = "drvfs";
        fsType = "9p";
      };
    };

    swapDevices = [
      {device = "/dev/sdb";}
    ];

    wsl = {
      enable = true;
      defaultUser = "kat";
      startMenuLaunchers = true;
      nativeSystemd = true;
      wslConf.automount.root = "/mnt";
    };

    boot.isContainer = true;

    services.openssh.enable = true;

    home-manager.users.kat = {
      services.gpg-agent.enable = false;
      programs.git.signing.gpgPath = "/mnt/c/Program Files (x86)/GnuPG/bin/gpg.exe";
      programs.zsh.profileExtra = ''
if [[ -n "$XDG_SESSION_ID" && "$TERM" == "dumb" &&
    "$(ps -p $PPID -o comm=)" == "login" ]]; then
    # Running in the background login process. Do nothing.
    return
fi
gpg-connect-agent killagent /bye &> /dev/null
WIN_USER="kat"
SSH_DIR="''${HOME}/.ssh" #
mkdir -p "''${SSH_DIR}"
wsl2_ssh_pageant_bin="''${SSH_DIR}/wsl2-ssh-pageant.exe"
ln -sf "/mnt/c/Users/''${WIN_USER}/.ssh/wsl2-ssh-pageant.exe" "''${wsl2_ssh_pageant_bin}"

listen_socket() {
  sock_path="$1" && shift
  fork_args="''${sock_path},fork"
  exec_args="''${wsl2_ssh_pageant_bin} $@"

  if ! ps x | grep -v grep | grep -q "''${fork_args}"; then
    rm -f "''${sock_path}"
    (setsid nohup socat "UNIX-LISTEN:''${fork_args}" "EXEC:''${exec_args}" &>/dev/null &)
  fi
}

# SSH
export SSH_AUTH_SOCK="''${SSH_DIR}/agent.sock"
listen_socket "''${SSH_AUTH_SOCK}"

# GPG
export GPG_AGENT_SOCK="''$(gpgconf --list-dirs socketdir)/S.gpg-agent"

if ! ss -a | grep -q "$GPG_AGENT_SOCK"; then
  echo "1"
  rm -rf "$GPG_AGENT_SOCK"
  if test -x "$wsl2_ssh_pageant_bin"; then
    (setsid nohup socat UNIX-LISTEN:"$GPG_AGENT_SOCK,fork" EXEC:"$wsl2_ssh_pageant_bin -gpg S.gpg-agent" >/dev/null 2>&1 &)
  else
    echo >&2 "WARNING: $wsl2_ssh_pageant_bin is not executable."
  fi
fi
export GPG_AGENT_SOCK="/home/kat/.gnupg/S.gpg-agent"

if ! ss -a | grep -q "$GPG_AGENT_SOCK"; then
  echo "1"
  rm -rf "$GPG_AGENT_SOCK"
  if test -x "$wsl2_ssh_pageant_bin"; then
    (setsid nohup socat UNIX-LISTEN:"$GPG_AGENT_SOCK,fork" EXEC:"$wsl2_ssh_pageant_bin -gpg S.gpg-agent" >/dev/null 2>&1 &)
  else
    echo >&2 "WARNING: $wsl2_ssh_pageant_bin is not executable."
  fi
fi
  unset wsl2_ssh_pageant_bin
      '';
    };

  programs.gnupg.agent.pinentryFlavor = mkForce "curses";

    networking = {
      hostId = "dddbb888";
      useDHCP = false;
    };

    system.stateVersion = "22.05";
  };
in {
  arch = "x86_64";
  type = "NixOS";
  modules = [
    hostConfig
  ];
}
