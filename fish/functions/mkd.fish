function mkd --description 'Create new dir and immediately cd into it.'
	mkdir --parents $argv; and cd $argv
end
