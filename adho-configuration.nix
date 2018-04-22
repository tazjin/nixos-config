# Local configuration for 'adho' (Thinkpad T470s)
{ config, pkgs, ...}:

{
  boot.initrd.luks.devices.adho.device = "/dev/disk/by-uuid/722006b0-9654-4ea1-8703-e0cf9ac1905e";
  services.xserver.libinput.enable = true;
  services.xserver.videoDrivers = [ "intel" ];
  programs.light.enable = true;

  # Office printer configuration
  services.printing.enable  = true;
  services.printing.drivers = [ pkgs.hplip ];
  services.avahi.enable     = true;
  services.avahi.nssmdns    = true;

  networking = {
    hostName = "adho";
    wireless.enable = true;
    wireless.userControlled.enable = true;

    wireless.networks = {
      # Welcome to roast club!
      "How do I computer fast?" = {
        psk = "washyourface";
      };

      # On the go!
      "Rumpetroll" = {
        psk = "fisk1234";
        # If this network exists, chances are that I want it:
        priority = 10;
      };

      # Public places in Oslo:
      "Abelone" = {
        psk = "speakeasy";
      };

      # Eugene's apartment:
      "GET_5G_4FD250" = {
        psk = "62636342";
      };

      # FSCONS 2017
      "uioguest" = {};

      # Hackeriet!
      "hackeriet.no" = {
        psk = "hackeriet.no";
      };

      # Cafe Sara
      "Sara Nett" = {
        psk = "sarabar1989";
      };

      # The Dubliner
      "DubGjest" = {
        # of course
        psk = "Guinness";
      };

      # Sync Compound
      "RWDS" = {
        psk = "radicalagenda";
      };

      "BrewDog" = {
        psk = "welovebeer";
      };

      # Dima's
      "What's a Bad Idea?" = {
        psk = "DQDxzrzIvy0YtDwH";
      };

      "SafetyWiFi - Teknologihuset" = {
        psk = "tech4ever";
      };

      "Selvaag Pluss" = {
        psk = "detlilleekstra";
      };

      "Langler" = {
        psk = "Oslo2018";
      };

      "Norwegian Internet Access" = {};
      "NSB_INTERAKTIV" = {};
      "The Thief" = {};
      "espressohouse" = {};
      "Gotanet Open" = {};
      "wifi.flytoget.no" = {};
      "AIRPORT" = {};
      "ilcaffelovesyou" = {};
      "WIFIonICE" = {};
      "Lorry Gjest" = {};
      "Amundsengjest" = {};
    };

    # Open Chromecast-related ports
    firewall.allowedTCPPorts = [ 5556 5558 ];
  };

  hardware.bluetooth.enable = true;

  # Configure POSIX queue limits (for work)
  systemd.tmpfiles.rules = let mqueue = "/proc/sys/fs/mqueue"; in [
    "w ${mqueue}/msgsize_max - - - - ${toString (64 * 1024)}"
    "w ${mqueue}/msg_max     - - - - 50"
  ];
}
