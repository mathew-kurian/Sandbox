#!/bin/bash

#synch all file/folders in public folder to s3 bucket
PATH=$PATH:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

cd /home/ec2-user/Dropbox/Muzzler/server/public
#aws s3 sync . s3://musicplayer --delete --cache-control "max-age=2592000" --expires "Fri, 24 Sep 2014 09:43:00 GMT" --grants read=uri=http://acs.amazonaws.com/groups/global/AllUsers full=emailaddress=salemkarani@gmail.com
#
#
aws s3 sync . s3://musicplayer --cache-control "max-age=2592000" --expires "Fri, 24 Sep 2014 09:43:00 GMT" --grants read=uri=http://acs.amazonaws.com/groups/global/AllUsers full=emailaddress=salemkarani@gmail.com
