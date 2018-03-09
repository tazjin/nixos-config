# Derivation for Emacs configured with the packages that I need:

{ pkgs ? import <nixos> {} }:

let emacsWithPackages = with pkgs; (emacsPackagesNgGen emacs).emacsWithPackages;
sly = with pkgs; emacsPackagesNg.melpaBuild {
  pname   = "sly";
  version = "20180221.1414";

  src = fetchFromGitHub {
    owner  = "joaotavora";
    repo   = "sly";
    rev    = "486bfbe95612bcdc0960c490207970a188e0fbb9";
    sha256 = "0ib4q4k3h3qn88pymyjjmlmnpizdn1mfg5gpk5a715nqsgxlg09l";
  };

  recipeFile = fetchurl {
    url    = "https://raw.githubusercontent.com/melpa/melpa/23b9e64887a290fca7c7ab2718f627f8d728575f/recipes/sly";
    sha256 = "1pmyqjk8fdlzwvrlx8h6fq0savksfny78fhmr8r7b07pi20y6n9l";
    name   = "sly";
  };
};

# Building sly-company requires quite some dancing because
# company-mode is required at build time.
trivialBuildWithCompany = with pkgs; callPackage <nixos/pkgs/build-support/emacs/trivial.nix> {
  emacs = with pkgs; emacsWithPackages(epkgs: [ epkgs.elpaPackages.company ]);
};

sly-company = with pkgs; trivialBuildWithCompany {
  pname   = "sly-company";
  version = "master";

  src = fetchFromGitHub {
    owner  = "joaotavora";
    repo   = "sly-company";
    rev    = "dfe18218e4b2ee9874394b50f82f5172f41c462c";
    sha256 = "1bj8w2wfq944cnhsk5xx41mfrjv89scrg4w98kqgda5drkpdf8a7";
  };
};

# The nix-mode in the official repositories is old and annoying to
# work with, pin it to something newer instead:
nix-mode = with pkgs; emacsPackagesNg.melpaBuild {
  pname   = "nix-mode";
  version = "20180306";

  src = fetchFromGitHub {
    owner  = "NixOS";
    repo   = "nix-mode";
    rev    = "0ac0271f6c8acdbfddfdbb1211a1972ae562ec17";
    sha256 = "157vy4xkvaqd76km47sh41wykbjmfrzvg40jxgppnalq9pjxfinp";
  };

  recipeFile = writeText "nix-mode-recipe" ''
    (nix-mode :repo "NixOS/nix-mode" :fetcher github
              :files (:defaults (:exclude "nix-mode-mmm.el")))
  '';
};

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
    intero
    magit
    markdown-mode-plus
    multi-term
    multiple-cursors
    paredit
    password-store
    racer
    rainbow-delimiters
    rust-mode
    s
    smart-mode-line
    string-edit
    terraform-mode
    yaml-mode
  ]) ++

  # Bleeding-edge packages:
  (with epkgs.melpaPackages; [
    edit-server
    helm-pass
    pg
    racket-mode
    restclient
    uuidgen
  ]) ++

  # Custom packaged Emacs packages:
  [ sly sly-company nix-mode ]
)
