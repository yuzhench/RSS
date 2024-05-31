docker rm rss_countainer_7_together

docker run -it \
    -v /home/yuzhen/Desktop/RSS/docker_container/build/RSS_package.txt:/home/yuzhen/RSS/resources/RSS_package.txt \
    -v /home/yuzhen/Desktop/RSS/docker_container/build/manba.sh:/home/yuzhen/RSS/resources/manba.sh \
    -v /home/yuzhen/Desktop/RSS/docker_container/build/environment.yml:/home/yuzhen/RSS/resources/environment.yml \
    -v /home/yuzhen/Desktop/RSS/docker_container/build/tensorrt_install.deb:/home/yuzhen/RSS/resources/tensorrt_install.deb \
    -v /home/yuzhen/Desktop/RSS/catkin_ws/src/KinfuROS:/home/yuzhen/RSS/catkin_ws/src/KinfuROS \
    --name rss_countainer_7_together \
    --gpus all --privileged -v /dev/dri:/dev/dri \
    -e DISPLAY=$DISPLAY \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    rss_image_together       

    #-e LIBGL_ALWAYS_INDIRECT=0
    # --net=host \
