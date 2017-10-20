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
    "i3/config".source = "${dotfiles}/i3.conf";
    "tmux.conf".source = "${dotfiles}/tmux.conf";
    "fish/config.fish".source = "${dotfiles}/config.fish";
    "rofi.conf".source = "${dotfiles}/rofi.conf";
    "alacritty.yml".source = "${dotfiles}/alacritty.yml";
  };
}
