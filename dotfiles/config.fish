# Configure classic prompt
set fish_color_user --bold blue
set fish_color_cwd --bold white

# Enable colour hints in VCS prompt:
set __fish_git_prompt_showcolorhints yes
set __fish_git_prompt_color_prefix purple
set __fish_git_prompt_color_suffix purple

# Fish configuration
set fish_greeting ""
set PATH $HOME/.local/bin $HOME/.cargo/bin $PATH

# Editor configuration
set -gx EDITOR "emacsclient"
set -gx ALTERNATE_EDITOR "emacs -q -nw"
set -gx VISUAL "emacsclient"

# Miscellaneous
eval (direnv hook fish)

# Useful command aliases
alias gpr 'git pull --rebase'
alias gco 'git checkout'
alias gf 'git fetch'
alias gap 'git add -p'
alias pbcopy 'xclip -selection clipboard'
alias edit 'emacsclient -n'
alias servedir 'nix-shell -p haskellPackages.wai-app-static --run warp'

# Old habits die hard (also ls is just easier to type):
alias ls 'exa'

# Fix up nix-env & friends for Nix 2.0
export NIX_REMOTE=daemon

# Fix display of fish in emacs' term-mode:
function fish_title
  true
end
