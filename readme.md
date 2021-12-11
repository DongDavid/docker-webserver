# 自动构建Docker镜像  

## 功能  

专门为thinkphp打包的镜像,因为php7.4不再支持`str{index}`的语法,所以还是用7.3的版本。
nginx的重写路由配置也直接设置为thinkphp5了
php-fpm改为sock

> 直接使用pecl install redis-5.1.1 的时候大概率会出现网络下载失败的问题导致镜像无法创建成功，所以直接ADD进去了

## 构建镜像
```sh
docker build -t dongdavid/webserver:7.3 .
```

## 使用镜像
```sh
# 启动
docker run -d --name web -p 80:80 -v $(pwd):/data dongdavid/webserver:7.3 && docker exec -it web /bin/bash
# 停止  
docker stop web
# 销毁
docker rm -f web
```  

默认站点根目录为`/data/public`  


> 7.4的配置和7.3不一样了， --with-freetype-dir 变成 --with-freetype, --with-jpeg-dir变--with-jpeg
> zip扩展需要先安装libzip-dev

## 版本说明  



### v7.3

nginx配置默认增为thinkphp的URL重写配置  
php-fpm增加了socket的方式
```
server {
    listen       80;
    server_name  _;
    root   /data/public;
    index  index.php index.html;
    access_log  off;
    location / {
        if (!-e $request_filename) {
            rewrite  ^(.*)$  /index.php?s=/$1  last;
        }
    }
    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/dev/shm/php-fpm.sock;
    }
}
```

* 增加了imagick-3.4.4扩展
* 增加了soap扩展

```
[PHP Modules]
bcmath
Core
ctype
curl
date
dom
fileinfo
filter
ftp
gd
hash
iconv
imagick
json
libxml
mbstring
mysqli
mysqlnd
openssl
pcntl
pcre
PDO
pdo_mysql
pdo_sqlite
Phar
posix
readline
redis
Reflection
session
SimpleXML
soap
sodium
SPL
sqlite3
standard
tokenizer
xdebug
xml
xmlreader
xmlwriter
zip
zlib

[Zend Modules]
Xdebug
```