# Fetch my wallpapers from git
with import <nixpkgs> {};

stdenv.mkDerivation {
  name    = "tazjins-wallpapers-1";

  src = fetchgit {
    url = "https://git.tazj.in/tazjin/wallpapers.git";
    rev = "3bce73b605ba5f848cb4e7cc33058a2be3952c68";
  };

  installPhase = ''
    mkdir -p $out/share/wallpapers
    cp -r $src/* $out/share/wallpapers
  '';

  meta = with stdenv.lib; {
    description = "tazjin's wallpaper collection";
    platforms = platforms.all;
  };
}
