# Derivation for Emacs pre-configured with packages that I need.

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

jsonrpc = emacsPackagesNg.elpaBuild rec {
  pname   = "jsonrpc";
  version = "1.0.0";

  src = fetchurl {
    url    = "https://elpa.gnu.org/packages/jsonrpc-${version}.el";
    sha256 = "06lmmn7j2ilkvwibbpgnd8p6d63fjjnxd2ma8f4jw6vrz1f7lwvs";
  };
};

eglot = emacsPackagesNg.melpaBuild rec {
  pname = "eglot";
  version = "1.1";

  src = fetchurl {
    url    = "https://elpa.gnu.org/packages/eglot-${version}.tar";
    sha256 = "01h4wh87lrd9l50y20gjjkgg760v8ixvbcb3q8jykl29989zw62y";
  };

  packageRequires = [ jsonrpc ];
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

counsel-notmuch = melpaBuild {
  pname   = "counsel-notmuch";
  version = "20171223";

  packageRequires = [
    newIvy.ivy
    pkgs.notmuch
  ];

  src = fetchFromGitHub {
    owner  = "fuxialexander";
    repo   = "counsel-notmuch";
    rev    = "ac1aaead81c6860d7b8324cc1c00bcd52de5e9ca";
    sha256 = "19frcrz6bx7d7v1hkg0xv7zmbk2sydlsdzn1s96cqzjk1illchkz";
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

sly = emacsPackagesNg.melpaBuild {
  pname           = "sly";
  version         = "20180613";
  packageRequires = [ elpaPackages.company ];

  src = fetchFromGitHub {
    owner  = "joaotavora";
    repo   = "sly";
    rev    = "a05b45f1564a86a9d49707c9c570da6c3a56b6e5";
    sha256 = "1c9xzppxlnak1px0dv0ljpp4izfj4377lncvrcb1jaiyh8z8ry48";
  };

  recipeFile = writeText "sly-recipe" ''
    (sly :files ("*.el"
                 ("lib" "lib/*")
                 ("contrib" "contrib/*")))
  '';
};

# EXWM pinned to a newer version than what is released due to a
# potential fix for ch11ng/exwm#425.
exwm = emacsPackagesNg.exwm.overrideAttrs(_: {
  version = "master";

  # This is not the original upstream repo, see PR:
  # https://github.com/ch11ng/exwm/pull/469/
  src = fetchFromGitHub {
    owner  = "medranocalvo";
    repo   = "exwm";
    rev    = "4c67a459c9f3d929e04a6b6ade452b203171e35b";
    sha256 = "0ia977m3wjkiccslbb3xf0m0bjmhys4c37j1prldi0rizrsf18r9";
 };
});

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
    alchemist
    browse-kill-ring
    cargo
    dash
    dash-functional
    dockerfile-mode
    edit-server
    elixir-mode
    erlang
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

  # Stable packages
  (with epkgs.melpaStablePackages; [
    intero
  ]) ++

  # Use custom updated ivy packages
  (lib.attrValues newIvy) ++

  # Custom packaged Emacs packages:
  [ nix-mode eglot prescient ivy-prescient counsel-notmuch pkgs.notmuch sly exwm ]
)
