{ pkgs, misc, ... }: {

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
