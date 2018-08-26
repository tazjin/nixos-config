# Local configuration for 'stallo' (Home desktop PC)
{ config, pkgs, ...}:

{
  boot.initrd.luks.devices.stallo-luks.device = "/dev/disk/by-uuid/b484cf1e-a27b-4785-8bd6-fa85a004b073";

  # Use proprietary nvidia driver
  services.xserver.videoDrivers = [ "nvidia" ];

  # Enable 32-bit compatibility for Steam:
  hardware.opengl.driSupport32Bit = true;
  hardware.pulseaudio.support32Bit = true;

  # Wine for Blizzard stuff
  environment.systemPackages = with pkgs.unstable; [ wineWowPackages.staging winetricks ];

  networking = {
    hostName = "stallo";
    wireless.enable = true;
    wireless.networks = {
      # Welcome to roast club!

      "How do I computer fast?" = {
        psk = "washyourface";
        # Prefer 5Ghz unless the card is acting up.
        priority = 10;
      };

      "How do I computer?" = {
        psk = "washyourface";
      };
    };
    # IPv6 at home, of course:
    nameservers = [
      "2606:4700:4700::1111"
      "2606:4700:4700::1001"
    ];
  };
}
