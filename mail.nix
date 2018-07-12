# This file configures offlineimap, notmuch and MSMTP.
#
# Some manual configuration is required the first time this is
# applied:
#
# 1. Credential setup.
# 2. Linking of MSMTP config (ln -s /etc/msmtprc ~/.msmtprc)
# 3. Linking of notmuch config (ln -s /etc/notmuch-config ~/.notmuch-config)

{ config, lib, pkgs, ... }:

let offlineImapConfig = pkgs.writeText "offlineimaprc"
  (builtins.readFile ./dotfiles/offlineimaprc);

msmtpConfig = pkgs.writeText "msmtprc"
  (builtins.readFile ./dotfiles/msmtprc);

notmuchConfig = pkgs.writeText "notmuch-config"
  (builtins.readFile ./dotfiles/notmuch-config);

tagConfig = pkgs.writeText "notmuch-tags" ''
  # Tag emacs-devel mailing list:
  -inbox +emacs-devel -- to:emacs-devel@gnu.org OR cc:emacs-devel@gnu.org

  # Tag nix-devel mailing list & discourse:
  -inbox +nix-devel -- to:nix-devel@googlegroups.com OR from:nixos1@discoursemail.com

  # Filter out Gitlab mails:
  -inbox +gitlab -- from:gitlab@aprila.no

  # Tag my own mail (from other devices) as sent:
  -inbox +sent -- folder:"aprila/Sende element" OR from:vincent@aprila.no OR from:mail@tazj.in

  # Drafts are always read, duh.
  -unread -- tag:draft

  # Tag development list
  -inbox +aprila-dev -- to:dev@aprila.no OR cc:dev@aprila.no
'';

notmuchIndex = pkgs.writeShellScriptBin "notmuch-index" ''
  echo "Indexing new mails in notmuch"

  # Index new mail
  ${pkgs.notmuch}/bin/notmuch new

  # Apply tags
  cat ${tagConfig} | ${pkgs.notmuch}/bin/notmuch tag --batch

  echo "Done indexing new mails"
'';
in {
  # Enable OfflineIMAP timer & service:
  systemd.user.timers.offlineimap = {
    description = "OfflineIMAP timer";
    wantedBy    = [ "timers.target" ];

    timerConfig = {
      Unit       = "offlineimap.service";
      OnCalendar = "*:0/2"; # every 2 minutes
      Persistent = "true"; # persist timer state after reboots
    };
  };

  systemd.user.services.offlineimap = {
    description = "OfflineIMAP service";
    path = with pkgs; [ pass notmuch ];

    serviceConfig = {
      Type            = "oneshot";
      ExecStart       = "${pkgs.offlineimap}/bin/offlineimap -u syslog -o -c ${offlineImapConfig}";
      ExecStartPost   = "${notmuchIndex}/bin/notmuch-index";
      TimeoutStartSec = "2min";
    };
  };

  # Link configuration files to /etc/ (from where they will be linked
  # further):
  environment.etc = {
    "msmtprc".source = msmtpConfig;
    "notmuch-config".source = notmuchConfig;
  };
}
