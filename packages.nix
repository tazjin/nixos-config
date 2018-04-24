# This file contains configuration for packages to install.
# It does not contain configuration for software that is already covered
# by other NixOS options (e.g. emacs)

{ config, pkgs, ... }:

let
  fetchChannel = { rev, sha256 }: import (fetchTarball {
    inherit sha256;
    url = "https://github.com/NixOS/nixpkgs-channels/archive/${rev}.tar.gz";
  }) { config.allowUnfree = true; };

  # Channels last updated: 2014-04-22

  # Instead of relying on Nix channels and ending up with out-of-sync
  # situations between machines, the commit for the stable Nix channel
  # is pinned here.
  stable = fetchChannel {
    rev    = "06c576b0525da85f2de86b3c13bb796d6a0c20f6";
    sha256 = "01cra89drfjf3yhii5na0j5ivap2wcs0h8i0xcxrjs946nk4pp5j";
  };

  # Certain packages from unstable are required in my daily setup. To
  # get access to them, they are hand-picked from the unstable channel
  # and set as overrides on the system package set.
  unstable = fetchChannel {
    rev = "6c064e6b1f34a8416f990db0cc617a7195f71588";
    sha256 = "1rqzh475xn43phagrr30lb0fd292c1s8as53irihsnd5wcksnbyd";
  };
in {
  # Configure the Nix package manager
  nixpkgs = {
    config.allowUnfree = true;
    # To use the pinned channel, the original package set is thrown
    # away in the overrides:
    config.packageOverrides = oldPkgs: stable // {
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
    binutils-unwrapped
    cargo
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
    kontemplate
    kubernetes
    lispPackages.quicklisp
    lxappearance-gtk3
    manpages
    maven
    mq-cli
    nixops
    numix-cursor-theme
    numix-gtk-theme
    numix-icon-theme
    openjdk
    openssl
    openssl.dev
    pass
    pavucontrol
    pkgconfig
    pulseaudio-ctl
    qjackctl
    ripgrep
    rustc
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
