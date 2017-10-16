with import <nixpkgs> {};

# Build and install my nixfd tool.
with rustPlatform;

buildRustPackage rec {
  name = "nixfd-${version}";
  version = "0.1.0";

  # This hash is of course total bullshit due to the dummy libc dependency
  # caused by:
  # https://github.com/NixOS/nixpkgs/issues/22737
  depsSha256 = "0iihnyq50qbq0fkvcj5jxilcw7d3bwd1x3gwcq0mzrcah23say0j";

  src = fetchFromGitHub {
    owner = "tazjin";
    repo = "nixfd";
    rev = "dbadc9ef8486070f26677154fa032a47d732b7a9";
    sha256 = "162301lc4znlqbansmaw9sla1rwi2s5nfmhl3z752n6aj2gcvz89";
  };

  meta = with stdenv.lib; {
    description = "Tired of waiting for nix-env -qaP?";
    homepage = https://github.com/tazjin/nixfd;
    license = licenses.mit;
    platforms = platforms.all;
  };
}
