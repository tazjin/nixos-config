# Derivation for Emacs pre-configured with packages that I need.
#
# * TODO 2018-06-15: sly removed due to build error in unstable
{ pkgs }:

with pkgs.unstable; with emacsPackagesNg;
let emacsWithPackages = (emacsPackagesNgGen emacs).emacsWithPackages;

# The nix-mode in the official repositories is old and annoying to
# work with, pin it to something newer instead:
nix-mode = emacsPackagesNg.melpaBuild {
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

# The default Rust language server mode is not really usable, install
# `eglot` instead and hope for the best.
eglot = emacsPackagesNg.melpaBuild rec {
  pname = "eglot";
  version = "0.8";

  src = fetchFromGitHub {
    owner  = "joaotavora";
    repo   = "eglot";
    rev    = version;
    sha256 = "1avsry84sp3s2vr2iz9dphm579xgw8pqlwffl75gn5akykgazwdx";
  };
};

# ivy has not been updated in unstable for a while:
ivySource = fetchFromGitHub {
  owner  = "abo-abo";
  repo   = "swiper";
  rev    = "6f2939485d33e9b28022d3b6912a50669dcdd596";
  sha256 = "1f2i6hkcbiqdw7fr9vabsm32a0gy647llzki6b97yv8vwa0klh2q";
};

withIvySources = pname: recipe: emacsPackagesNg.melpaBuild {
  inherit pname;
  version = "20180616";
  recipeFile = builtins.toFile "${pname}-recipe" recipe;
  src = ivySource;
};

newIvy.ivy = withIvySources "ivy" ''
(ivy :files (:defaults
             (:exclude "swiper.el" "counsel.el" "ivy-hydra.el")
             "doc/ivy-help.org"))
'';

newIvy.counsel = withIvySources "counsel" ''
(counsel :files ("counsel.el"))
'';

newIvy.swiper = withIvySources "swiper" ''
(swiper :files ("swiper.el"))
'';

newIvy.ivy-pass = melpaBuild {
  pname = "ivy-pass";
  version = "20170812";
  src = fetchFromGitHub {
    owner  = "ecraven";
    repo   = "ivy-pass";
    rev    = "5b523de1151f2109fdd6a8114d0af12eef83d3c5";
    sha256 = "18crb4zh2pjf0cmv3b913m9vfng27girjwfqc3mk7vqd1r5a49yk";
  };
};

# prescient & ivy-prescient provide better filtering in ivy/counsel,
# but they are not in nixpkgs yet:
prescientSource = fetchFromGitHub {
  owner  = "raxod502";
  repo   = "prescient.el";
  rev    = "27c94636489d5b062970a0f7e9041ca186b6b659";
  sha256 = "05jk8cms48dhpbaimmx3akmnq32fgbc0q4dja7lvpvssmq398cn7";
};

prescient = emacsPackagesNg.melpaBuild {
  pname   = "prescient";
  version = "1.0";
  src     = prescientSource;

  recipeFile = writeText "prescient-recipe" ''
    (prescient :files ("prescient.el"))
  '';
};

ivy-prescient = emacsPackagesNg.melpaBuild {
  pname   = "ivy-prescient";
  version = "1.0";
  src     = prescientSource;
  packageRequires = [ prescient newIvy.ivy ];

  recipeFile = writeText "ivy-prescient-recipe" ''
    (ivy-prescient :files ("ivy-prescient.el"))
  '';
};

in emacsWithPackages(epkgs:
  # Actual ELPA packages (the enlightened!)
  (with epkgs.elpaPackages; [
    ace-window
    adjust-parens
    avy
    company
    pinentry
    rainbow-mode
    undo-tree
    which-key
  ]) ++

  # MELPA packages:
  (with epkgs.melpaPackages; [
    browse-kill-ring
    cargo
    dash
    dash-functional
    dockerfile-mode
    edit-server
    erlang
    exwm
    go-mode
    gruber-darker-theme
    haskell-mode
    ht
    hydra
    idle-highlight-mode
    jq-mode
    kotlin-mode
    magit
    markdown-mode
    markdown-toc
    multi-term
    multiple-cursors
    nginx-mode
    paredit
    password-store
    pg
    rainbow-delimiters
    restclient
    rust-mode
    s
    smartparens
    string-edit
    telephone-line
    terraform-mode
    toml-mode
    use-package
    uuidgen
    web-mode
    websocket
    yaml-mode
  ]) ++

  # Use custom updated ivy packages
  (lib.attrValues newIvy) ++

  # Custom packaged Emacs packages:
  [ nix-mode eglot prescient ivy-prescient pkgs.notmuch ]
)
