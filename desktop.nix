# Configuration for the desktop environment

{ config, pkgs, ... }:

let wallpapers = import ./pkgs/wallpapers.nix;
in {
  # Configure basic X-server stuff:
  services.xserver = {
    enable = true;
    layout = "us,no";
    xkbOptions = "caps:super, grp:shifts_toggle";
  };

  # configure desktop environment:
  services.xserver.windowManager.i3 = {
    enable = true;
    configFile = "/etc/i3/config";
  };

  services.compton.enable = true;
  # this should be the default! in fact, it will soon be:
  # https://github.com/NixOS/nixpkgs/pull/30486
  services.compton.backend = "xrender";

  # Configure Redshift for Oslo
  services.redshift = {
    enable = true;
    latitude = "59.911491";
    longitude = "10.757933";
  };

  # Configure fonts
  fonts = {
    fonts = with pkgs; [
      font-awesome-ttf
      input-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      powerline-fonts
    ];
  };

  # Configure random setting of wallpapers
  systemd.user.services.feh-wp = {
    description = "Randomly set wallpaper via feh";
    serviceConfig = {
      Type             = "oneshot";
      WorkingDirectory = "${wallpapers}/share/wallpapers";

      # Manually shuffle because feh's --randomize option can't be restricted to
      # just certain file types.
      ExecStart = "${pkgs.bash}/bin/bash -c '${pkgs.fd}/bin/fd -atf | shuf | head -n1 | ${pkgs.findutils}/bin/xargs ${pkgs.feh}/bin/feh --bg-fill'";
    };
  };

  systemd.user.timers.feh-wp = {
    description = "Set a random wallpaper every hour";
    wantedBy    = [ "graphical-session.target" ];
    partOf      = [ "graphical-session.target" ];

    timerConfig = {
      OnActiveSec     = "1second";
      OnUnitActiveSec = "1hour";
    };
  };
}
