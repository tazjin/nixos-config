with import <nixpkgs> {};

stdenv.mkDerivation rec {
  name = "stern-${version}";
  version = "1.5.1";

  src = fetchurl {
    url = "https://github.com/wercker/stern/releases/download/${version}/stern_linux_amd64";
    sha256 = "0xjxhgi1mlkbqimf0fk5cxr6lvwxrr2z49bnw4b1vqpd1gdqjyiv";
    name = "stern";
  };

  phases = "installPhase";
  installPhase = ''
    mkdir -p $out/bin
    cp $src $out/bin/stern
    chmod +x $out/bin/stern
  '';

  meta = with stdenv.lib; {
    description = "Multi pod and container log tailing for Kubernetes";
    homepage = "https://github.com/wercker/stern";
  };
}

