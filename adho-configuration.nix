# Local configuration for 'adho' (Thinkpad T470s)
{ config, ...}:

{
  networking.hostName = "adho";
  services.xserver.libinput.enable = true;
}
