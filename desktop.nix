# Configuration for the desktop environment

{ config, pkgs, ... }:

let wallpapers = import ./pkgs/wallpapers.nix;
in {
  # Configure basic X-server stuff:
  services.xserver.enable = true;
  services.xserver.layout = "us,no";
  services.xserver.xkbOptions = "caps:super, grp:shifts_toggle";

  # configure desktop environment:
  services.xserver.windowManager.i3 = {
    enable = true;
    configFile = "/etc/i3/config";
  };

  services.compton.enable = true;
  services.compton.backend = "xrender"; # this should be the default!

  # Configure Redshift for Oslo
  services.redshift.enable = true;
  services.redshift.latitude = "59.911491";
  services.redshift.longitude = "10.757933";

  # Configure fonts
  fonts = {
    fonts = with pkgs; [
      input-fonts
    ];
  };

  # Ensure wallpapers are "installed"
  environment.systemPackages = [ wallpapers ];

  # Configure random setting of wallpapers
  systemd.user.services.feh-wp = {
    description = "Randomly set wallpaper via feh";
    serviceConfig = {
      Type = "oneshot";
      WorkingDirectory = "${wallpapers}/share/wallpapers";
      ExecStart = "${pkgs.bash}/bin/bash -c '${pkgs.fd}/bin/fd -atf | shuf | head -n1 | ${pkgs.findutils}/bin/xargs ${pkgs.feh}/bin/feh --bg-fill'";
    };
  };

  systemd.user.timers.feh-wp = {
    description = "Set a random wallpaper every hour";
    wantedBy = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];

    timerConfig = {
      OnActiveSec = "1second";
      OnUnitActiveSec = "1hour";
    };
  };
}
