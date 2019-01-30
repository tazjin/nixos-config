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
    rev    = "d96c7a356383302db4426a0d5a8383af921d964f";
    sha256 = "0hlhczh3m077rwrhp4smf3zd2sfj38h2c126bycv66m0aff0gycn";
  };

  # Certain packages from unstable are hand-picked into the package
  # set.
  unstable = fetchChannel {
    rev    = "32bcd72bf28a971c9063a9cdcc32effe49f49331";
    sha256 = "1f74m18r6xl9s55jbkj9bjhdxg2489kwjam4d96pf9rzq0i1f8li";
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

      # Backport Exa from unstable until a fix for the Rust builder is
      # backported.
      #
      # https://github.com/NixOS/nixpkgs/pull/48020
      exa = unstable.exa;

      wallpapers = import ./pkgs/wallpapers.nix;
      pulseaudio-ctl = import pkgs/pulseaudio-ctl.nix;
    };
  };

  # ... and declare packages to be installed.
  environment.systemPackages = with pkgs; [
    # Default nixos.* packages:
    alacritty
    binutils-unwrapped
    chromium
    curl
    direnv
    dnsutils
    dotnet-sdk
    evince
    exa
    extremetuxracer
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
    hicolor-icon-theme
    htop
    i3lock
    iftop
    jq
    kontemplate
    kubernetes
    lispPackages.quicklisp
    lxappearance-gtk3
    manpages
    maven
    mono
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
