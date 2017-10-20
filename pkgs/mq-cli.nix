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
  depsSha256 = "1mdh5adnf58qn0gm2l9bp9dar2h577wvnhnlq8wj8a54vmgpp3ic";

  src = fetchFromGitHub {
    owner  = "aprilabank";
    repo   = "mq-cli";
    rev    = "2c71e092f69f5cd3c31ad8a84aa4168118579898";
    sha256 = "10m11fis5dv3v9y5rg48nbg7170bzakdban5mrjaj2vkv9qgslii";
  };

  meta = with stdenv.lib; {
    description = "CLI interface to POSIX message queues";
    homepage    = https://github.com/aprilabank/mq-cli;
    license     = licenses.mit;
  };
}
