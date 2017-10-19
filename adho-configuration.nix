# Local configuration for 'adho' (Thinkpad T470s)
{ config, ...}:

{
  boot.initrd.luks.devices.adho.device = "/dev/disk/by-uuid/722006b0-9654-4ea1-8703-e0cf9ac1905e";
  networking.hostName = "adho";
  services.xserver.libinput.enable = true;
  services.xserver.videoDrivers = [ "intel" ];
  programs.light.enable = true;

  networking.wireless.enable = true;
  networking.wireless.networks = {
    # Welcome to roast club!
    "How do I computer?" = {
      psk = "washyourface";
    };

    # Did someone say wifi credentials are secret?
    # http://bit.ly/2gI43QP
    "Amesto-mobile" = {
      psk = "ostemAt1";
    };

    # Public places in Oslo:
    "Abelone" = {
      psk = "speakeasy";
    };
  };

  hardware.bluetooth.enable = true;
}
