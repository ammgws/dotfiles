function mkd --description 'Create new dir and immediately cd into it.'
	mkdir -p $argv; and cd $argv
end