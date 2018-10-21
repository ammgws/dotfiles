function check_vpn --description="Return true if connected to VPN"
  command curl --silent https://am.i.mullvad.net/json | jq '.mullvad_exit_ip'
end
