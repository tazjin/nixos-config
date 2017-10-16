# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [
    ./hardware-configuration.nix
    ./local-configuration.nix
    ./packages.nix
    ./wallpapers.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  hardware.pulseaudio.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Oslo";

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
  };

  security.sudo.enable = true;
  security.sudo.extraConfig = "wheel ALL=(ALL:ALL) SETENV: ALL";

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "17.09"; # Did you read the comment?
}
