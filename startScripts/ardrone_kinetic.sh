#!/bin/bash

xhost +local:root

disp="-e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix"
echo -e "\nWhat would you like to name your container?\n"
read container_tag

	docker run -ti \
                --net host \
                --name $container_tag \
		--env ROS_HOSTNAME=$USER \
		--env ROS_MASTER_URI=http://$USER:11311 \
		--workdir=/root/ard_ws \
		-e DISPLAY=$DISPLAY \
		-v /home/eric/ard_ws:/root/ard_ws \
                ric-ros:ardrone-kinetic-ws bash

