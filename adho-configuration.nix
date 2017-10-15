# Local configuration for 'adho' (Thinkpad T470s)
{ config, ...}:

{
  networking.hostName = "adho";
  networking.connman.enable = true;
  services.xserver.libinput.enable = true;
}
