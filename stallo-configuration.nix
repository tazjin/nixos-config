
# Local configuration for 'stallo' (Home desktop PC)
{ config, ...}:

{
  networking.hostName = "stallo";
  networking.wireless.enable = true;
  networking.wireless.networks = {
    "How do I computer fast?" = {
      # Welcome to roast club!
      psk = "washyourface";
    };
  };
}
