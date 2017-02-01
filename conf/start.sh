#!/bin/sh
   
# Generate hash:
HASH_DAV=`mkpasswd -m bcrypt ${PASSWORD}`
   
# Add user DAV:
echo "${USERNAME}:${HASH_DAV}" > /etc/lighttpd/htpasswd
   
chmod 0600 /etc/lighttpd/htpasswd
chown -hR www-data:www-data /etc/lighttpd/htpasswd
   
# Run server:
lighttpd -D -f /etc/lighttpd/lighttpd.conf