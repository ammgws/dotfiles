function wg_whitelist --description="Script to run before enabling Wireguard to whitelist IPs for Ubuntu sources so can update even when Wireguard service is down"
#TODO
     set data (apt-cache policy)
     for line in $data
         set --append URLs (string match --regex "^.*(http://\S+)" $line)[2]
     end
     for URL in URLs
         if set --local index (contains --index $URL $URLs)
   	     set --erase URLs[$index]
         end
     end
end
