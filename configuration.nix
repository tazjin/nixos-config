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
    ./desktop.nix
    ./dotfiles.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  hardware.pulseaudio.enable = true;
  time.timeZone = "Europe/Oslo";

  # Configure shell environment:
  programs.fish.enable = true;
  programs.ssh.startAgent = true;
  services.emacs.enable = true;
  services.emacs.defaultEditor = true;

  # Configure VirtualBox (needed for local NixOps testing):
  virtualisation.virtualbox.host.enable = true;

  # Configure Docker (with socket activation):
  # Side note: ... virtualisation? ...
  virtualisation.docker.enable = true;
  virtualisation.docker.autoPrune.enable = true;

  # Configure other random applications:
  programs.java.enable = true;

  # Configure user account
  users.defaultUserShell = pkgs.fish;
  users.extraUsers.vincent = {
    extraGroups = [ "wheel" "docker" ];
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
