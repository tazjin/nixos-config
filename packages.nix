# This file contains configuration for packages to install.
# It does not contain configuration for software that is already covered
# by other NixOS options (e.g. emacs)

{ config, pkgs, ... }:

let
  fetchChannel = { rev, sha256 }: import (fetchTarball {
    inherit sha256;
    url = "https://github.com/NixOS/nixpkgs-channels/archive/${rev}.tar.gz";
  }) { config.allowUnfree = true; };

  # Channels last updated: 2014-05-26

  # Instead of relying on Nix channels and ending up with out-of-sync
  # situations between machines, the commit for the stable Nix channel
  # is pinned here.
  stable = fetchChannel {
    rev    = "2f6440eb09b7e6e3322720ac91ce7e2cdeb413f9";
    sha256 = "0vb7ikjscrp2rw0dfw6pilxqpjm50l5qg2x2mn1vfh93dkl2aan7";
  };

  # Certain packages from unstable are hand-picked into the package
  # set.
  unstable = fetchChannel {
    rev    = "5da85431fb1df4fb3ac36730b2591ccc9bdf5c21";
    sha256 = "0pc15wh5al9dmhcj29gwqir3wzpyk2nrplibr5xjk2bdvw6sv6c1";
  };

  # Temporarily import a commit from master directly to pick emacs26.
  # Should be removed once that update is in nixos-unstable.
  master = import (fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/288ce0cb845c03fafa1f3c673440e9922f22131a.tar.gz";
  }) {};
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
      emacs = master.emacs;

      # Override various Emacs packages from unstable:
      pinnedEmacs = with unstable.emacsPackagesNg; {
        inherit
          counsel
          counsel-tramp
          exwm
          ivy
          ivy-gitlab
          ivy-hydra
          ivy-pass
          markdown-mode
          markdown-toc
          swiper;
      };
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
    evince
    exa
    fd
    file
    firefox-unwrapped
    fish
    gcc
    git
    gnome3.dconf
    gnome3.glib_networking
    gnumake
    gnupg
    google-cloud-sdk
    gopass
    htop
    i3lock
    iftop
    # Upstream link is down:
    # jetbrains.idea-ultimate
    jq
    kontemplate
    kubernetes
    lispPackages.quicklisp
    lxappearance-gtk3
    manpages
    maven
    msmtp
    mq-cli
    ngrok
    nixops
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
    qjackctl
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
    thinkfan
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
    haskellPackages.intero
    haskellPackages.stylish-haskell
    haskellPackages.yesod-bin
  ];
}
