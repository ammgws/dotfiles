function wget --description='wrapper to force use of XDG config dir'
    command wget --hsts-file=$XDG_CONFIG_HOME/wget/wget-hsts $argv
end
