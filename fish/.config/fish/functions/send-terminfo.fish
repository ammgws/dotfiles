function send-terminfo \
    --description="Send terminfo to remote server" \
    --argument-names=remote_server port

    if test -z $remote_server
        echo "Usage: send-terminfo user@server port"
        return 1
    end
    if test -z $port
        set remote_port 22
    end

    infocmp $TERM | ssh $remote_server -p$port "bash -c 'mkdir --parents .terminfo && cat >/tmp/ti && tic /tmp/ti'"
end
