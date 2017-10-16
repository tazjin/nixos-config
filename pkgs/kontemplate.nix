# Install the latest kontemplate version
with import <nixpkgs> {};

stdenv.mkDerivation {
  name = "kontemplate-1.2.0";

  src = fetchzip {
    url = "https://github.com/tazjin/kontemplate/releases/download/v1.2.0/kontemplate-1.2.0-f8b6ad6-linux-amd64.tar.gz";
    sha256 = "09siirhr1m9lc91bkw4h4l1qpnjnl03yr5m9mjfxdkp5gzmkcb9r";
  };

  installPhase = ''
    mkdir -p $out/bin
    mv kontemplate $out/bin/kontemplate
  '';

  meta = with stdenv.lib; {
    description = "Extremely simple Kubernetes resource templates";
    homepage = "http://kontemplate.works";
    license = licenses.mit;
  };
}
