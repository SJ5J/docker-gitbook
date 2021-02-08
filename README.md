# docker-gitbook
#1. 下载本仓库

git clone https://github.com/SJ5J/docker-gitbook.git
cd ./docker-gitbook

#2. SUMMARY.md是我的笔记，要编辑或替换成你自己的，或者直接删掉。
#3. gitbook_plugin.tar 里是gitbook的配置文件book.json 和对应的插件
#放这个包的作用是跳过gitbook install 下载插件，加快容器启动

#4. 构建镜像

docker build ./ -t gitbook:3.2.0

#5. 启动容器 $YOUR_PATH 替换成你的绝对路径

docker run -itd --rm --name gitbook \
-p 4000:4000 -p 35729:35729 \
-v $YOUR_PATH/docker-gitbook:/book \
gitbook:3.2.0

#6. 浏览器访问

http://localhost:4000


#7. 进入容器(可选)

docker exec -ti gitbook /bin/bash


#8. book_start.sh 容器启动脚本用法
#8.1 容器启动时默认动作是启动gitbook服务，即执行

book_start.sh serve /book/ /book/docs/

#8.2 如果只需要初始化SUMMARY.md， 即 gitbook init，则

book_start.sh init /book/

#8.3 如果只是想更新生成最新的html，则

book_start.sh build /book/ /book/docs/
