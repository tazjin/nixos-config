# This file contains configuration for packages to install.
# It does not contain configuration for software that is already covered
# by other NixOS options (e.g. emacs)

{ config, pkgs, ... }:

let
  # Channels last updated: 2014-04-22


  # Certain packages from unstable are required in my daily setup. To
  # get access to them, they are hand-picked from the unstable channel
  # and set as overrides on the system package set.
  unstable = import (pkgs.fetchFromGitHub {
    owner  = "NixOS";
    repo   = "nixpkgs-channels";
    rev    = "6c064e6b1f34a8416f990db0cc617a7195f71588";
    sha256 = "1rqzh475xn43phagrr30lb0fd292c1s8as53irihsnd5wcksnbyd";
  }) { config.allowUnfree = true; };
in {
  # Configure the Nix package manager
  nixpkgs = {
    config.allowUnfree = true;
    config.packageOverrides = oldPkgs: oldPkgs // {
      wallpapers = import ./pkgs/wallpapers.nix;
      pulseaudio-ctl = import pkgs/pulseaudio-ctl.nix;

      kontemplate = unstable.kontemplate;
      mq-cli = unstable.mq-cli;

      # Override EXWM from 0.17 -> 0.18
      pinnedEmacs.exwm = unstable.emacsPackagesNg.elpaPackages.exwm;
    };
  };

  # ... and declare packages to be installed.
  environment.systemPackages = with pkgs; [
    # Default nixos.* packages:
    alacritty
    curl
    direnv
    dnsutils
    exa
    fd
    firefox-bin
    fish
    gcc
    git
    gnome3.dconf
    gnome3.evolution
    gnome3.glib_networking
    gnumake
    gnupg
    google-cloud-sdk
    gopass
    htop
    i3lock
    iftop
    jetbrains.idea-ultimate
    jq
    kubernetes
    kontemplate
    lispPackages.quicklisp
    lxappearance-gtk3
    manpages
    maven
    mq-cli
    nixops
    numix-gtk-theme
    numix-icon-theme
    numix-cursor-theme
    openjdk
    openssl
    openssl.dev
    pass
    pavucontrol
    pulseaudio-ctl
    pkgconfig
    qjackctl
    ripgrep
    rustracer
    sbcl
    spotify
    stdmanpages
    tdesktop
    terraform_0_10
    tig
    tmux
    tree
    unzip
    xclip
    xfce.xfce4-screenshooter

    # Haskell packages:
    cabal-install
    ghc
    hlint
    stack
    stack2nix
    haskellPackages.intero
    haskellPackages.stylish-haskell
    haskellPackages.yesod-bin
  ];
}
