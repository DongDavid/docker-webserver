#!/bin/bash
rootpath=$(cd ../;pwd)

echo -n "please set hostname(default:localhost)"
read hostname  

if [[ $hostname == "" ]]; then
	hostname="localhost"
fi

host_ip=`/sbin/ifconfig -a|grep inet|grep -v 127.0.0.1|grep -v inet6|awk '{print $2}'|tr -d "addr:"`

echo '宿主机ip:'$host_ip
echo "hostname is "$hostname


docker run -d \
--name web \
#-p 9000:9000 \
-p 80:80 \
-v $rootpath/data:/data:rw \
#-v $rootpath/server/nginx:/etc/nginx/sites-available:rw \
#--add-host $hostname:$host_ip \
dongdavid/webserver:lasted

#docker run -d --name web -p 80:80 -v $pwd:/data:rw dongdavid/webserver:lasted
#docker run -d -p 3307:3306 -e MYSQL_ROOT_PASSWORD=root --name mysql57 mysql:5.7
