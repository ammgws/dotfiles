function tv_get_volume
    lgtv audio getVolume | jq --raw-output '.. | objects | select(.type == "response") | .payload | .volume'
end
