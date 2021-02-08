# docker-gitbook
#下载本仓库

git clone https://github.com/SJ5J/docker-gitbook.git
cd ./docker-gitbook

#这个SUMMARY.md是我的笔记，要编辑或替换成你自己的，或者直接删掉。

#构建镜像

docker build ./ -t gitbook:3.2.0

#启动容器 $YOUR_PATH 替换成你的绝对路径

docker run -itd --rm --name gitbook \
-p 4000:4000 -p 35729:35729 \
-v $YOUR_PATH/docker-gitbook:/book \
gitbook:3.2.0

#进入容器

docker exec -ti gitbook /bin/bash
