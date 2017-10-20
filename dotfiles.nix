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
    mkdir -p $out/dotfiles
    cp ./* $out/dotfiles/
  '';
};
in {
  # /etc/ is a special place in NixOS!
  # Symlinks that need to be created there must be specified explicitly.
  environment.etc = {
    "i3/config" = {
      source = "${dotfiles}/dotfiles/i3.conf";
      # Setting a mode causes Nix to copy the file instead of symlinking it.
      # For i3 config in particular this is desirable because I want to be able
      # to modify and reload it before committing a change.
      mode = "0644";
    };
  };
}
