# Local configuration for 'stallo' (Home desktop PC)
{ config, ...}:

{
  boot.initrd.luks.devices.stallo-luks.device = "/dev/disk/by-uuid/b484cf1e-a27b-4785-8bd6-fa85a004b073";

  services.openssh.enable = true;

  # Use proprietary nvidia driver
  services.xserver.videoDrivers = [ "nvidia" ];

  networking = {
    hostName = "stallo";
    wireless.enable = true;
    wireless.networks = {
      "How do I computer fast?" = {
        # Welcome to roast club!
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
