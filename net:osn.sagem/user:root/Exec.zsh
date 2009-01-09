
< /var/log/sudo.log sed 's/^\([^ ]\)/---> \1/' | awk 'BEGIN { RS="---> " ; FS=" ;" } ! /COMMAND=\/usr\/bin\/zsh/ { printf $0 }' > /var/log/.sudo.log && mv -f /var/log/.sudo.log /var/log/sudo.log

