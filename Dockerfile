FROM ubuntu:18.04
LABEL author=SJ

ARG GIT_BOOK_VERSION=3.2.0
ARG NODE_VERSION=10.23.0
LABEL version=$GIT_BOOK_VERSION

ENV ROOT_PATH=/book
#html路径名必须是docs，以便用github的pages服务托管
ENV BOOK_PATH=$ROOT_PATH/docs
ENV MD_PATH=$ROOT_PATH

WORKDIR $ROOT_PATH
#VOLUME [ "$ROOT_PATH" ]
EXPOSE 4000 35729

ARG HOME=/root
ENV NVM_DIR=$HOME/.nvm
ENV PATH=$NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH
#ENV NODE_PATH=$NVM_DIR/v$NODE_VERSION/lib/node_modules

#免tzdata安装交互
ENV DEBIAN_FRONTEND=noninteractive

RUN echo "*************apt source update************" && \
    #rm /bin/sh && ln -s /bin/bash /bin/sh && \
    #sed -i s@/archive.ubuntu.com/@/mirrors.aliyun.com/@g /etc/apt/sources.list && \
    sed -i 's/archive.ubuntu.com/mirrors.aliyun.com/g' /etc/apt/sources.list && \
    sed -i 's/security.ubuntu.com/mirrors.ustc.edu.cn/g' /etc/apt/sources.list && \
    apt-get update

RUN echo "*************intall and Config gitbook************" && \
    apt-get install -y \
    --no-install-recommends --allow-unauthenticated \
    calibre git curl ca-certificates && \
    apt-get clean && apt-get autoclean && \
    #export NVM_DIR="$HOME/.nvm" && \
      git clone https://github.com/nvm-sh/nvm.git "$NVM_DIR" && \
      cd "$NVM_DIR" && \
      git checkout `git describe --abbrev=0 --tags --match "v[0-9]*" $(git rev-list --tags --max-count=1)` && \
    \. "$NVM_DIR/nvm.sh" && \
    echo "export NVM_DIR=\"$HOME/.nvm\"" >> ~/.bashrc && \
    echo "[ -s \"$NVM_DIR/nvm.sh\" ] && \. \"$NVM_DIR/nvm.sh\"" >> ~/.bashrc && \
    /bin/bash -c "source ~/.bashrc" && \
    nvm install $NODE_VERSION && \
    npm install gitbook-cli -g --registry=https://registry.npm.taobao.org && \
    npm config set registry https://registry.npm.taobao.org -g && \
    npm config set disturl https://npm.taobao.org/dist -g && \
    gitbook fetch ${GIT_BOOK_VERSION} && \
    #修改用户目录的.gitbook\3.2.0.js文件，把112行的confirm改为false。
    sed -i '112 s/true/false/g' ~/.gitbook/versions/$GIT_BOOK_VERSION/lib/output/website/copyPluginAssets.js && \
    npm cache clear --force && \
    rm -rf /tmp/* 

ENTRYPOINT [ "/bin/bash", "-c" ]
CMD [ "chmod 755 $ROOT_PATH/book_start.sh; $ROOT_PATH/book_start.sh serve $MD_PATH $BOOK_PATH" ]
