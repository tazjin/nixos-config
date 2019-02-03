# home-manager configuration used on ChromeOS systems

{ config, pkgs, ... }:

{
  # Allow non-free software (fonts, IDEA, etc.):
  nixpkgs.config.allowUnfree = true;

  # Install various useful packages:
  home.packages = with pkgs; [
    bat
    exa
    gnupg
    google-cloud-sdk
    htop
    pass
    ripgrep
    tdesktop
    transmission
    tree

    # Fonts to make available in X11 applications:
    input-fonts

    # Emacs configuration stays in the normal ~/.emacs.d location (for
    # now), hence this package is not installed via `programs.emacs`.
    (import ./emacs.nix { inherit pkgs; })
  ];

  programs.git = {
    enable = true;
    userEmail = "mail@tazj.in";
    userName = "Vincent Ambo";
  };

  services.gpg-agent = {
    enable = true;
    extraConfig = ''
      pinentry-program ${pkgs.pinentry}/bin/pinentry-gtk-2
      allow-emacs-pinentry
    '';
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  manual.html.enable = true;

  # Shell configuration
  #
  # There are some differences between the ChromeOS / NixOS
  # configurations, so instead of fixing up the dotfile to support
  # both I opted for keeping the configuration here.
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      # Configure classic prompt
      set fish_color_user --bold blue
      set fish_color_cwd --bold white

      # Enable colour hints in VCS prompt:
      set __fish_git_prompt_showcolorhints yes
      set __fish_git_prompt_color_prefix purple
      set __fish_git_prompt_color_suffix purple

      # Fish configuration
      set fish_greeting ""

      # Fix up nix-env & friends for Nix 2.0
      export NIX_REMOTE=daemon
    '';
  };

  # Ensure fonts installed via Nix are picked up.
  fonts.fontconfig.enableProfileFonts = true;
}
