function tmux --wraps tmux --description 'tmux preset with XDG config file location'
    command tmux -f $XDG_CONFIG_HOME/tmux/tmux.conf $argv
end
