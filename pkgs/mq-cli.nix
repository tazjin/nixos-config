# Build and install mq-cli.

with import <nixpkgs> {};

let
  # The cached Cargo registry moves *very* slowly, override it:
  newRegistry = rustRegistry.overrideAttrs (oldAttrs: rec {
    name = "rustRegistry-2017-10-20";
    src = fetchFromGitHub {
      owner  = "rust-lang";
      repo   = "crates.io-index";
      rev    = "a1e85af8f57ba61e505c2cb2dc359b66caf355e9";
      sha256 = "0xcszw287kqlz15ikflsim36mrvpvlb2y074vg22szz0r48nn06v";
    };
  });
in rustPlatform.buildRustPackage rec {
  name = "mqcli-${version}";
  version = "0.1.0";

  rustRegistry = newRegistry;
  depsSha256 = "138a4dgwhf78bnmxz2ibxqz1wifq5046czxd0w8a4gwngy2ryiqs";

  src = fetchFromGitHub {
    owner  = "aprilabank";
    repo   = "mq-cli";
    rev    = "d908fe1cbc7de0bff7cadbe0b3851d50229b7de2";
    sha256 = "0c4myav65dzks53q4grin9lhcz1jzpddqnihf2h9lm098dhrswkp";
  };

  meta = with stdenv.lib; {
    description = "CLI interface to POSIX message queues";
    homepage    = https://github.com/aprilabank/mq-cli;
    license     = licenses.mit;
  };
}
