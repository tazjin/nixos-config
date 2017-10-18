# Package to install a Terraform binary release.
# This is necessary because the Terraform package on Nix does not currently
# build for some reason.

with import <nixpkgs> {};

stdenv.mkDerivation rec {
  name = "terraform-${version}";
  version = "0.10.7";

  src = fetchzip {
    url = "https://releases.hashicorp.com/terraform/0.10.7/terraform_0.10.7_linux_amd64.zip";
    sha256 = "189g94bb1d3wxzp720a5vki91czsqmk728469wa1fdkl43cdqd2n";
  };

  installPhase = ''
    mkdir -p $out/bin
    mv terraform $out/bin/terraform
  '';

  meta = with stdenv.lib; {
    description = "Terraform is a tool for building, changing, and combining infrastructure safely and efficiently";
    homepage = "https://www.terraform.io/";
    license  = licenses.mpl20;
  };
}
