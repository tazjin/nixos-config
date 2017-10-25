NixOS configuration
===================

My NixOS config. Some manual steps required before the first run!

Make sure submodules are cloned: `git submodule update --init`.

Set up the unstable NixOS channel:

```
nix-channel --add http://nixos.org/channels/nixos-unstable nixos-unstable
nix-channel --update
```

Symlink local machine configuration to `/etc/nixos/local-configuration.nix`.
