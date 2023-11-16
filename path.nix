{ pkgs, misc, ... }: {
  # DO NOT EDIT: This file is managed by fleek. Manual changes will be overwritten.
 home.sessionPath = [ 
    "$HOME/go/bin"
    "$HOME/.krew/bin"
    "$HOME/.jbang/bin"
    "$PYENV_ROOT/bin"
    "$HOME/.cargo/bin"
    "$HOME/bin"
    "$HOME/.local/bin"
 ];
}
