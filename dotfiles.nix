# Bundle configuration files into a derivation.
# I call this derivation dotfiles despite that not technically being true
# anymore ...

{ config, pkgs, ...}:

let dotfiles = pkgs.stdenv.mkDerivation {
  name = "tazjins-dotfiles";

  srcs = [
    ./dotfiles
  ];

  installPhase = ''
    mkdir -p $out
    cp ./* $out/
  '';
};
in {
  # /etc/ is a special place in NixOS!
  # Symlinks that need to be created there must be specified explicitly.
  environment.etc = {
    "alacritty.yml".source    = "${dotfiles}/alacritty.yml";
    "fish/config.fish".source = "${dotfiles}/config.fish";
    "tmux.conf".source        = "${dotfiles}/tmux.conf";
  };
}
