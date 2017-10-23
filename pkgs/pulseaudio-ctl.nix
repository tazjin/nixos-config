with import <nixpkgs> {};

stdenv.mkDerivation rec {
  name = "pulseaudio-ctl-${version}";
  version = "v1.66";

  src = fetchzip {
    url = "https://github.com/graysky2/pulseaudio-ctl/archive/${version}.tar.gz";
    sha256 = "19a24w7y19551ar41q848w7r1imqkl9cpff4dpb7yry7qp1yjg0y";
  };

  buildFlags = ''PREFIX=$(out)'';

  # Force Nix to detect the runtime dependency on 'bc'
  preInstall = ''
    sed -i 's|bc)|${bc}/bin/bc)|g' common/pulseaudio-ctl
  '';

  installFlags = ''PREFIX=$(out)'';

  meta = with stdenv.lib; {
    description = "Control pulseaudio volume from the shell or mapped to keyboard shortcuts";
    homepage = "https://github.com/graysky2/pulseaudio-ctl";
    license = licenses.mit;
  };
}
