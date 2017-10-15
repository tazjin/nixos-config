# Local configuration for 'adho' (Thinkpad T470s)
{ config, ...}:

{
  boot.initrd.luks.devices.adho.device = "/dev/disk/by-uuid/722006b0-9654-4ea1-8703-e0cf9ac1905e";
  networking.hostName = "adho";
  networking.connman.enable = true;
  services.xserver.libinput.enable = true;
}
