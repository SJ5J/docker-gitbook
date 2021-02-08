# docker-gitbook
#下载本仓库
git clone https://github.com/SJ5J/docker-gitbook.git
cd ./docker-gitbook

#构建镜像
docker build ./ -t gitbook:3.2.0

#启动容器
docker run -itd --rm --name gitbook \
-p 4000:4000 -p 35729:35729 \
-v /home/sj/gitbook:/book \
gitbook:3.2.0

#进入容器
docker exec -ti gitbook /bin/bash
