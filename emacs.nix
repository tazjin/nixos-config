# Derivation for Emacs configured with the packages that I need:

{ pkgs ? import <nixpkgs> {} }:

let emacsWithPackages = with pkgs; (emacsPackagesNgGen emacs).emacsWithPackages;

# Custom code for packages missing from the current Nix packages.

in emacsWithPackages(epkgs:
  # Actual ELPA packages (the enlightened!)
  (with epkgs.elpaPackages; [
    ace-window
    adjust-parens
    avy
    company
    exwm
    pinentry
    rainbow-mode
    undo-tree
    which-key
  ]) ++

  # Stable packages:
  (with epkgs.melpaStablePackages; [
    browse-kill-ring
    cargo
    dash
    dash-functional
    dockerfile-mode
    erlang
    flycheck
    go-mode
    gruber-darker-theme
    haskell-mode
    helm
    ht
    idle-highlight-mode
    magit
    markdown-mode-plus
    multi-term
    multiple-cursors
    nix-mode
    paredit
    password-store
    racer
    rainbow-delimiters
    rust-mode
    s
    sly
    sly-company
    smart-mode-line
    string-edit
    terraform-mode
    yaml-mode
  ]) ++

  # Bleeding-edge packages:
  (with epkgs.melpaPackages; [
    helm-pass
    pg
    racket-mode
    restclient
    sly-quicklisp
    uuidgen
  ])
)
