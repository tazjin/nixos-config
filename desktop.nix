# Configuration for the desktop environment

{ config, lib, pkgs, ... }:

let wallpapers = import ./pkgs/wallpapers.nix;
in {
  # Configure basic X-server stuff:
  services.xserver = {
    enable = true;
    layout = "us,no";
    xkbOptions = "caps:super, grp:shifts_toggle";

    # Give EXWM permission to control the session.
    displayManager.sessionCommands = "${pkgs.xorg.xhost}/bin/xhost +SI:localuser:$USER";
  };


  # Apparently when you have house guests they complain about your screen tearing!
  services.compton.enable = true;
  services.compton.backend = "xrender";

  # Configure desktop environment:
  services.xserver.windowManager.session = lib.singleton {
    name = "exwm";
    start = ''
      ${pkgs.emacs}/bin/emacs --daemon -f exwm-enable
      emacsclient -c
    '';
  };

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
