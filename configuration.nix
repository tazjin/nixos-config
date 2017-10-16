# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

let
  unstable = import <nixos-unstable> { config.allowUnfree = true; };
in {
  imports =
    [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./local-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  hardware.pulseaudio.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Oslo";

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    curl gnumake unzip openjdk gcc htop tree direnv tmux fish ripgrep
    gnupg pass git manpages stdmanpages
  ];

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.layout = "us,no";
  services.xserver.xkbOptions = "caps:super, grp:shifts_toggle";

  # Configure i3 & compositor
  services.xserver.windowManager.i3.enable = true;
  services.compton.enable = true;
  services.compton.backend = "xrender";

  # Configure Redshift for Oslo
  services.redshift.enable = true;
  services.redshift.latitude = "59.911491";
  services.redshift.longitude = "10.757933";

  # Configure shell environment
  programs.fish.enable = true;
  programs.ssh.startAgent = true;
  services.emacs.enable = true;
  services.emacs.defaultEditor = true;

  # Configure other random applications:
  programs.java.enable = true;
  nixpkgs.config.allowUnfree = true;

  # Configure fonts
  fonts = {
    fonts = with pkgs; [
      input-fonts
    ];
  };
  
  # Configure user account
  users.defaultUserShell = pkgs.fish;
  users.extraUsers.vincent = {
    extraGroups = [ "wheel" ];
    isNormalUser = true;
    uid = 1000;
    shell = pkgs.fish;
    packages = with pkgs; [
      jetbrains.idea-community pavucontrol spotify xclip tdesktop
      rofi rofi-pass alacritty i3lock unstable.firefox-beta-bin fd
      tig kubernetes xfce.xfce4-screenshooter exa lxappearance-gtk3
      numix-gtk-theme numix-icon-theme unstable.numix-cursor-theme
    ];
  };

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

  security.sudo.enable = true;
  security.sudo.extraConfig = "wheel ALL=(ALL:ALL) SETENV: ALL";

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "17.09"; # Did you read the comment?
}
