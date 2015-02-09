#/bin/sh
cd /home/ec2-user/Dropbox/muzzler/server
export PKG_CONFIG_PATH='/usr/local/lib/pkgconfig'  
export LD_LIBRARY_PATH='/usr/local/lib':$LD_LIBRARY_PATH 
forever app.js
