function fish_title
    # emacs is basically the only term that can't handle it.
    if not set -q INSIDE_EMACS
        if string match --quiet --regex micro (status current-command)
            # TODO: find way to show command args as well so can show filename
            echo -n (status current-command)
        else
            echo -n (status current-command)
        end
        echo (__fish_pwd | string replace --regex "^/home/"(id --name --user) " ~")
    end
end
