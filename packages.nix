# This file contains configuration for packages to install.
# It does not contain configuration for software that is already covered
# by other NixOS options (e.g. emacs)

{ config, pkgs, ... }:

let
  fetchChannel = { rev, sha256 }: import (fetchTarball {
    inherit sha256;
    url = "https://github.com/NixOS/nixpkgs-channels/archive/${rev}.tar.gz";
  }) { config.allowUnfree = true; };

  # Channels last updated: 2014-05-14

  # Instead of relying on Nix channels and ending up with out-of-sync
  # situations between machines, the commit for the stable Nix channel
  # is pinned here.
  stable = fetchChannel {
    rev    = "ef74cafd3e5914fdadd08bf20303328d72d65d6c";
    sha256 = "0xj5gv8k40vi7fczrqv0ppcmhczddh30kyizvzfg5wyc15fm2dmg";
  };

  # Certain packages from unstable are required in my daily setup. To
  # get access to them, they are hand-picked from the unstable channel
  # and set as overrides on the system package set.
  unstable = fetchChannel {
    rev    = "6db7f92cc2af827e8b8b181bf5ed828a1d0f141d";
    sha256 = "1hpgn22j35mgfyrrkgyg28fm4mzllk5wfv5mrrn29kiglqb462fr";
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

      # Override various Emacs packages from unstable:
      pinnedEmacs = with unstable.emacsPackagesNg; {
        inherit
          company-lsp
          counsel
          counsel-tramp
          exwm
          ivy
          ivy-gitlab
          ivy-hydra
          ivy-pass
          lsp-mode
          lsp-rust
          lsp-ui
          markdown-mode
          swiper;
      };
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
    ngrok
    nixops
    notmuch
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
    pwgen
    qjackctl
    ripgrep
    rustup
    sbcl
    screen
    siege
    spotify
    stdmanpages
    tdesktop
    terraform_0_10
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
