# 自动构建Docker镜像  



> 直接使用pecl install redis-5.1.1 的时候大概率会出现网络下载失败的问题导致镜像无法创建成功，所以直接ADD进去了

## 构建镜像
```sh
docker build -t dongdavid/webserver:latest .
```

## 使用镜像
```sh
# 启动
docker run -d --name web -p 80:80 -v $(pwd):/data dongdavid/webserver:7.4 && docker exec -it web /bin/bash
# 销毁
docker stop web && docker rm web
```  

默认站点根目录为`/data/public`  


> 7.4的配置和7.3不一样了， --with-freetype-dir 变成 --with-freetype
> zip扩展需要先安装libzip-dev

## 版本说明  



### v1.0.0

nginx配置默认增加了laravel和thinkphp的URL重写配置  

```
server {
    listen       80;
    server_name  _;
    .
    .
    .
    location / {

    }
}


server {
    listen       80;
    server_name  la.test;
    .
    .
    .
    location / {
		try_files $uri $uri/ /index.php?$query_string;
    }
}
server {
    listen       80;
    server_name  tp.test;
    .
    .
    .
    location / {
        if (!-e $request_filename) {
            rewrite  ^(.*)$  /index.php?s=/$1  last;
        }
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