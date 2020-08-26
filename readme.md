# 自动构建Docker镜像  



> 直接使用pecl install redis-5.1.1 的时候大概率会出现网络下载失败的问题导致镜像无法创建成功，所以直接ADD进去了

## 构建镜像
```sh
docker build -t dongdavid/webserver:7.4 .
```

## 使用镜像
```sh
# 启动
docker run -d --name web -p 80:80 -v $(pwd):/var/www/html dongdavid/webserver:7.4 && docker exec -it web /bin/bash
# 销毁
docker stop web && docker rm web
```  

默认站点根目录为`/var/www/html/public`  


> 7.4的配置和7.3不一样了， --with-freetype-dir 变成 --with-freetype
> zip扩展需要先安装libzip-dev