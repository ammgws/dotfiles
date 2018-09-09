function send-terminfo \
  --description="Send terminfo to remote server" \
  --argument-names=remote_server remote_port

  if test -z $remote_server
    echo "Usage: send-terminfo user@server port"
    return 1
  end
  if test -z $remote_port
    echo "Usage: send-terminfo user@server port"
    return 1
  end

  switch $SHELL
    case "*fish"
      infocmp $TERM | ssh $remote_server -p$sshport "mkdir --parents .terminfo; and cat >/tmp/ti; and tic /tmp/ti"
    case "*bash"
      infocmp $TERM | ssh $remote_server -p$sshport "mkdir --parents .terminfo && cat >/tmp/ti && tic /tmp/ti"
  end
end
