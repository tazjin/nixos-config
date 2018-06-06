NixOS configuration
===================

My NixOS configuration! It configures most of the packages I require
on my systems, sets up Emacs the way I need and does a bunch of other
interesting things.

In contrast with earlier versions of this configuration, the Nix
channel versions are now pinned in Nix (see the beginning of
[packages.nix][]).

Machine-local configuration is kept in files with the naming scheme
`$hostname-configuration.nix` and **must** be symlinked to
`local-configuration.nix` before the first configuration run.

I'm publishing this repository (and my [emacs configuration][]) as a
convenience for myself, but also as a resource that people looking for
example Nix or Emacs configurations can browse through.

Feel free to ping me with any questions you might have.

[packages.nix]: packages.nix
[emacs configuration]: https://github.com/tazjin/emacs.d
