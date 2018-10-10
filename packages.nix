# This file contains configuration for packages to install.
# It does not contain configuration for software that is already covered
# by other NixOS options (e.g. emacs)

{ config, pkgs, ... }:

let
  fetchChannel = { rev, sha256 }: import (fetchTarball {
    inherit sha256;
    url = "https://github.com/NixOS/nixpkgs-channels/archive/${rev}.tar.gz";
  }) { config.allowUnfree = true; };

  # Channels last updated: 2018-10-10
  #
  # Instead of relying on Nix channels and ending up with out-of-sync
  # situations between machines, the commit for the stable Nix channel
  # is pinned here.
  stable = fetchChannel {
    rev    = "59fe4c7f17a8efd9fe182bb23f47554d4b1d98c2";
    sha256 = "1g72vxax29s0yyknficbwwwrk4h7z8cm6vaxyh5524cljhcdq246";
  };

  # Certain packages from unstable are hand-picked into the package
  # set.
  unstable = fetchChannel {
    rev    = "0a7e258012b60cbe530a756f09a4f2516786d370";
    sha256 = "1g72vxax29s0yyknficbwwwrk4h7z8cm6vaxyh5524cljhcdq246";
  };
in {
  # Configure the Nix package manager
  nixpkgs = {
    config.allowUnfree = true;
    # To use the pinned channel, the original package set is thrown
    # away in the overrides:
    config.packageOverrides = oldPkgs: stable // {
      # Store whole unstable channel in case that other modules need
      # it (see emacs.nix for example):
      inherit unstable;

      wallpapers = import ./pkgs/wallpapers.nix;
      pulseaudio-ctl = import pkgs/pulseaudio-ctl.nix;
    };
  };

  # ... and declare packages to be installed.
  environment.systemPackages = with pkgs; [
    # Default nixos.* packages:
    alacritty
    binutils-unwrapped
    curl
    direnv
    dnsutils
    evince
    exa
    fd
    file
    firefox-unwrapped
    fish
    gcc
    git
    gnumake
    gnupg
    google-cloud-sdk
    gopass
    htop
    hicolor-icon-theme
    i3lock
    iftop
    # Upstream link is down:
    # jetbrains.idea-ultimate
    extremetuxracer
    jq
    kontemplate
    kubernetes
    lispPackages.quicklisp
    lxappearance-gtk3
    manpages
    maven
    mq-cli
    msmtp
    ngrok
    notmuch
    numix-cursor-theme
    numix-gtk-theme
    numix-icon-theme
    offlineimap
    openjdk
    openssl
    openssl.dev
    pass
    pavucontrol
    pkgconfig
    pulseaudio-ctl
    pwgen
    ripgrep
    rustup
    sbcl
    screen
    siege
    spotify
    stdmanpages
    systemd.dev
    tdesktop
    terraform
    tig
    tmux
    tokei
    transmission
    tree
    units
    unzip
    vlc
    xclip
    xfce.xfce4-screenshooter

    # Haskell packages:
    cabal-install
    ghc
    hlint
    stack
    stack2nix
    haskellPackages.stylish-haskell
    haskellPackages.yesod-bin
  ];
}
