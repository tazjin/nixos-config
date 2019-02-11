# Local configuration for 'adho' (Thinkpad T470s)
{ config, pkgs, ...}:

{
  boot.initrd.luks.devices.adho.device = "/dev/disk/by-uuid/722006b0-9654-4ea1-8703-e0cf9ac1905e";
  boot.kernelModules = [ "kvm-intel" ];

  services.xserver.libinput.enable = true;
  services.xserver.videoDrivers = [ "intel" ];
  programs.light.enable = true;

  # Office printer configuration
  services.printing.enable  = true;
  services.printing.drivers = [ pkgs.hplip ];
  services.avahi.enable     = true;
  services.avahi.nssmdns    = true;

  # Enable VirtualBox to update Beatstep Pro firmware:
  virtualisation.virtualbox.host.enable = true;
  virtualisation.virtualbox.host.enableExtensionPack = true;

  # Enable LXC/LXD for Nixini work
  virtualisation.lxd.enable = true;

  # Give me more entropy:
  services.haveged.enable = true;

  # Disable sandbox to let work-builds function:
  nix.useSandbox = false;

  # Yubikey related:
  services.pcscd.enable = true;
  environment.systemPackages = with pkgs; [
    cfssl
    libp11
    opensc
    yubico-piv-tool
  ];

  networking = {
    hostName = "adho";
    wireless.enable = true;
    wireless.userControlled.enable = true;

    wireless.networks = {
      # Welcome to roast club!
      "How do I computer?" = {
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

      "Wurst" = {
        psk = "wurst2015";
      };

      "postkontoret" = {
        psk = "postkontoret";
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

      "MAGNAT Guest" = {
        psk = "elmolino021";
      };

      "BrewDog" = {
        psk = "welovebeer";
      };

      # Dima's
      "What's a Bad Idea?" = {
        psk = "DQDxzrzIvy0YtDwH";
      };

      # Loke's
      "VMC28F76E" = {
        psk = "d2ftQnr6xppw";
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

      # Pils & Programmering
      "BEKKguest" = {
        psk = "guest7890";
      };

      "Homan-Gjest" = {
        psk = "haveaniceday";
      };

      # Røverstaden
      "Roverstaden" = {
        psk = "r0verstaden2018";
      };

      "The Brew Dock" = {
        psk = "realbeer";
      };

      "econ-guest" = {
        psk = "Finance2010";
      };

      "KabelBox-2FD0" = {
        psk = "92433048597489095671";
      };

      "TheKasbah" = {
        psk = "couscous";
      };

      # Kitty's misspelled network.
      "How do I Computer?" = {
        psk = "herpderpponies";
      };

      # NixCon 2018
      "Coin Street Community Builders " = {
        psk = "3vents2016";
      };

      "KH2 Gjest" = {
        psk = "haenfindag";
      };

      # Forest & Brown
      "Forest Guest" = {
        psk = "437B99AC5B";
      };

      "Gatwick FREE Wi-Fi" = {};
      "mycloud" = {};
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
      "Beer Palace Gjest" = {};
      "ibis" = {};
      "GoogleGuest" = {};
    };
  };

  hardware.bluetooth.enable = true;

  # Configure POSIX queue limits (for work)
  systemd.tmpfiles.rules = let mqueue = "/proc/sys/fs/mqueue"; in [
    "w ${mqueue}/msgsize_max - - - - ${toString (64 * 1024)}"
    "w ${mqueue}/msg_max     - - - - 50"
  ];
}
