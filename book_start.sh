#!/bin/bash
#电子书根目录，参考Dockerfile的VOLUME挂载点
#生成html的目录名必须是docs，以便用github的pages服务托管
ROOT_PATH=$PWD
PLUGIN_PACKAGE=gitbook_plugin.tar.gz

CMD=$1
MD_PATH=$2
BOOK_PATH=$3


if [ $CMD != "serve" -a $CMD != "init" -a $CMD != "build" ] ||
   ([ $CMD == "serve" -o  $CMD == "build" ]) && [ $# -ne 3 ] ||
   [ $CMD == "init" -a $# -ne 2 ];then

    echo "usage:"
    echo "To start gitbook:   ./book_start.sh serve PATH_TO_MARKDOWN PATH_TO_HTML"
    echo "To build html book: ./book_start.sh build PATH_TO_MARKDOWN PATH_TO_HTML"
    echo "To generate SUMMARY.md: ./book_start.sh init PATH_TO_MARKDOWN"
    exit 0
fi

# init SUMMARY.md and md file directory

if [ ! -d "$MD_PATH" ]; then
    # MD_PATH 目录不存在
    mkdir -p "$MD_PATH"
    cp -f $ROOT_PATH/SUMMARY.md $ROOT_PATH/README.md $ROOT_PATH/introduction.md $MD_PATH/
elif [ "`ls -A $MD_PATH`" = "" ]; then
    #MD_PATH 目录为空
    cp -f $ROOT_PATH/SUMMARY.md $ROOT_PATH/README.md $ROOT_PATH/introduction.md $MD_PATH/
fi

# 初始化生成空的SUMMARY.md文件和对应目录，格式： gitbook init [生成SUMMARY.md 的路径]
gitbook init $MD_PATH/

if [ $CMD == "init" ]; then
    exit 0
fi

# init html book path
if [ ! -d "$BOOK_PATH" ]; then
    #BOOK_PATH 目录不存在
    mkdir -p $BOOK_PATH
fi

if [ "`ls -A $BOOK_PATH`" = "" ]; then
    #BOOK_PATH 目录为空
    #如果没网络可以复制下载好的gitbook插件，并跳过下载插件这步 #gitbook install $BOOK_PATH/
    #cp -f $ROOT_PATH/book.json $BOOK_PATH/
    tar xzf $ROOT_PATH/$PLUGIN_PACKAGE -C $BOOK_PATH/
    #rm -f $ROOT_PATH/gitbook_plugin.tar
fi

#$CMD == "build"
#如果更新了md文档，可以用这个build命令生成新的html，但是gitbook会自动更新所以用不到

#$CMD == "serve" ]; then
#gitbook serve [SUMMARY.md 所在路径] [生成html的目标路径]
#nohup gitbook serve $ROOT_PATH/ $ROOT_PATH/html/ 2>&1 &
gitbook $CMD $MD_PATH/ $BOOK_PATH/ 2>&1
exit 0

