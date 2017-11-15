{ pkgs ? import <nixpkgs> {} }:

with pkgs; stdenv.mkDerivation rec {
  name = "gopass-bin-${version}";
  version = "1.6.1";

  src = fetchzip {
    url = "https://github.com/justwatchcom/gopass/releases/download/v${version}/gopass-${version}-linux-386.tar.gz";
    sha256 = "06iif74akcfb8n1h3ggig56a8y854p4dc7dpxpdfy6w9ra514phq";
  };

  phases = "installPhase";
  installPhase = ''
    mkdir -p $out/bin $out/share/fish/completions
    cp $src/fish.completion $out/share/fish/completions/gopass.fish
    cp $src/gopass $out/bin/gopass
    chmod +x $out/bin/gopass
  '';

  meta = with stdenv.lib; {
    description = "password-store like password manager with team functionality";
    license     = licenses.mit;
    homepage    = "https://github.com/justwatchcom/gopass";
  };
}
