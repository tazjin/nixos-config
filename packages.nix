# This file contains configuration for packages to install.
# It does not contain configuration for software that is already covered
# by other NixOS options (e.g. emacs)

{ config, pkgs, ... }:

let unstable = import <nixos-unstable> { config.allowUnfree = true; };
    rust-overlay = import nixpkgs-mozilla/rust-overlay.nix;
in {
  # Configure the Nix package manager
  nixpkgs.config.allowUnfree = true;
  nixpkgs.overlays = [ rust-overlay ];

  # ... and declare packages to be installed.
  environment.systemPackages = with pkgs; [
    # Default nixos.* packages:
    alacritty
    curl
    direnv
    dnsutils
    exa
    fd
    fish
    gcc
    git
    gnome3.dconf
    gnome3.evolution
    gnome3.glib_networking
    gnumake
    gnupg
    google-cloud-sdk
    htop
    i3lock
    iftop
    jetbrains.idea-ultimate
    jq
    kubernetes
    lxappearance-gtk3
    manpages
    maven
    nixops
    numix-gtk-theme
    numix-icon-theme
    openjdk
    openssl
    openssl.dev
    pass
    pavucontrol
    pkgconfig
    qjackctl
    ripgrep
    rofi
    rofi-pass
    rustracer
    spotify
    stdmanpages
    tdesktop
    tig
    tmux
    tree
    unzip
    xclip
    xfce.xfce4-screenshooter

    # nixos-unstable.* packages:
    unstable.firefox-beta-bin
    unstable.numix-cursor-theme

    # Overlay packages:
    latest.rustChannels.stable.rust

    # Custom packages:
    (import pkgs/kontemplate.nix)
    (import pkgs/mq-cli.nix)
    (import pkgs/nixfd.nix)
    (import pkgs/pulseaudio-ctl.nix)
    (import pkgs/stern-bin.nix)
    (import pkgs/terraform-bin.nix)
    (import pkgs/gopass-bin.nix { inherit pkgs; })
  ];
}

