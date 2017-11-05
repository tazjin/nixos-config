# Install the latest kontemplate version
with import <nixpkgs> {};

stdenv.mkDerivation {
  name = "kontemplate-1.3.0";

  src = fetchzip {
    url = "https://github.com/tazjin/kontemplate/releases/download/v1.3.0/kontemplate-1.3.0-98daa6b-linux-amd64.tar.gz";
    sha256 = "0byybdc1xli96rxyg3wf7548b055ca355qavi435riwlkmn9c5da";
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
