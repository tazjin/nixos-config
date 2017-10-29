# Local configuration for 'adho' (Thinkpad T470s)
{ config, pkgs, ...}:

{
  boot.initrd.luks.devices.adho.device = "/dev/disk/by-uuid/722006b0-9654-4ea1-8703-e0cf9ac1905e";
  services.xserver.libinput.enable = true;
  services.xserver.videoDrivers = [ "intel" ];
  programs.light.enable = true;

  # Attempt to get Steam & co to run:
  hardware.opengl.driSupport32Bit = true;
  hardware.pulseaudio.support32Bit = true;
  environment.systemPackages = [ pkgs.steam ];

  networking = {
    hostName = "adho";
    wireless.enable = true;
    wireless.userControlled.enable = true;

    wireless.networks = {
      # Welcome to roast club!
      "How do I computer fast?" = {
        psk = "washyourface";
      };

      # Did someone say wifi credentials are secret?
      # http://bit.ly/2gI43QP
      "Amesto-mobile" = {
        psk = "ostemAt1";
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
    };
  };

  hardware.bluetooth.enable = true;

  # Configure POSIX queue limits (for work)
  systemd.tmpfiles.rules = let mqueue = "/proc/sys/fs/mqueue"; in [
    "w ${mqueue}/msgsize_max - - - - ${toString (64 * 1024)}"
    "w ${mqueue}/msg_max     - - - - 50"
  ];
}
