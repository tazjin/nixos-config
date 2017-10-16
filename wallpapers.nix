# Configuration for randomly setting wallpapers.
{ config, pkgs, ... }:

{
  # Configure random setting of wallpapers
  systemd.user.services.clone-wallpapers = {
    description = "Clone wallpaper repository";
    enable = true;
    before = [ "feh-wp.service" "feh-wp.timer" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.fish}/bin/fish -c '${pkgs.coreutils}/bin/stat %h/wallpapers; or ${pkgs.git}/bin/git clone https://git.tazj.in/tazjin/wallpapers.git %h/wallpapers'";
    };
  };

  systemd.user.services.feh-wp = {
    description = "Randomly set wallpaper via feh";
    serviceConfig = {
      Type = "oneshot";
      WorkingDirectory = "%h/wallpapers";
      ExecStart = "${pkgs.bash}/bin/bash -c '${pkgs.fd}/bin/fd -atf | shuf | head -n1 | ${pkgs.findutils}/bin/xargs ${pkgs.feh}/bin/feh --bg-fill'";
    };
  };

  systemd.user.timers.feh-wp = {
    description = "Set a random wallpaper every hour";
    wantedBy = [ "timers.target" ];

    timerConfig = {
      OnActiveSec = "3second";
      OnUnitActiveSec = "1hour";
    };
  };
}
