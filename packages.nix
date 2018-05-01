# This file contains configuration for packages to install.
# It does not contain configuration for software that is already covered
# by other NixOS options (e.g. emacs)

{ config, pkgs, ... }:

let
  fetchChannel = { rev, sha256 }: import (fetchTarball {
    inherit sha256;
    url = "https://github.com/NixOS/nixpkgs-channels/archive/${rev}.tar.gz";
  }) { config.allowUnfree = true; };

  # Channels last updated: 2014-05-01

  # Instead of relying on Nix channels and ending up with out-of-sync
  # situations between machines, the commit for the stable Nix channel
  # is pinned here.
  stable = fetchChannel {
    rev    = "ce0d9d638ded6119f19d87e433e160603683fb1b";
    sha256 = "0na6kjk4xw6gqrn3a903yv3zfa64bspq2q3kd6wyf52y44j3s8sx";
  };

  # Certain packages from unstable are required in my daily setup. To
  # get access to them, they are hand-picked from the unstable channel
  # and set as overrides on the system package set.
  unstable = fetchChannel {
    rev    = "1b1be29bf827fc177100ae175030b2fda4132e47";
    sha256 = "0dnwyvh2xfbf35apf17iw59hscf1jdqn8nx7hm7yh9c0ypkh2qy3";
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
