#!/bin/bash
CONTAINER_NAME="gitbook"
CONTAINER_ID=gitbook-"$USER"
GID=$(id -g)

if [ $# == 1 ];then
    if [ $1 == "enter" ];then
        docker exec -ti $CONTAINER_ID /bin/bash
        exit 0
    else
        echo "usage:"
        echo "To start $CONTAINER_NAME, just run ./$CONTAINER_NAME.sh"
        echo "To enter the container: "
        echo "    First, run: ./$CONTAINER_NAME.sh"
        echo "    Second, run: ./$CONTAINER_NAME.sh enter"
        exit 0
    fi
fi

docker ps -a | grep $CONTAINER_ID > /dev/null
if [ $? == 0 ]; then
    echo "Your container is existing, stop it"
    docker stop $CONTAINER_ID
    sleep 2
fi

#--cpuset-cpus=$CPUSET \
docker run -dti --rm \
--name=$CONTAINER_ID \
--net=host \
-p 4000:4000 -p 35729:35729 \
-e LANG=C.UTF-8 \
-v /home/sj/gitbook:/book \
-w /book/ \
-e BOOK_USER=$UID \
-e BOOK_GROUP=$GID \
$CONTAINER_NAME:3.2.0 /bin/bash
#/book/gitbook_start.sh
