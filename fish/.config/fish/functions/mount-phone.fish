# WIP
function mount-phone
    set LOCAL_MNT_DIR ~/mnt/

    set DEPENDENCIES simple-mtpfs
    for dependency in $DEPENDENCIES
        if not type -q $dependency
            echo "You must have $dependency installed."
            return 1
        end
    end

    #TODO: Handle error when nothing plugged in and other errors
    #simple-mtpfs: symbol lookup error: /usr/lib/libmtp.so.9: undefined symbol: 
    #libusb_handle_events_timeout_completed
    #test: Missing argument at index 2
    #Select device:

    set devices (simple-mtpfs --list-devices)
    if test $devices = "No raw devices found."
        echo "No devices found. Check connection?"
        return 1
    else
        echo "Select device:"
    end
end
