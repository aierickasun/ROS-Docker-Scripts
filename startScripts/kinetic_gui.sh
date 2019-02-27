#!/bin/bash

echo -e "\nWhich image will you be running?: e.g. \n\t<$USER/repo:tag>\n"
read repo_tag

echo -e "\nWhich network do you want to connect to?: [run docker network ls to see list]\n"
read network_tag

echo -e "\nMount a volume?[y/n]\n"
read volume_resp

is_yes() {
        yesses={y,Y,yes,Yes,YES}
        if [[ $yesses =~ $1 ]]; then
                echo 1
        fi
        }

is_no() {
        noses={n,N,no,No,No}
        if [[ $noses =~ $1 ]]; then
                echo 1
        fi
        }

if [ $(is_yes $volume_resp) ]; then
	echo -e "\nHow would you like to mount the volume?[$host_path:$client_path]\n"
	read volume_tag
fi

echo -e "\nWhat would you like to name your container?\n"
read container_tag

disp="-e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix"

if [ $(is_yes $volume_resp) ]; then
        docker run -it --rm \
	        --net $network_tag \
       		--name $container_tag \
        	--env ROS_HOSTNAME=$container_tag \
		--env ROS_MASTER_URI=http://master:11311 \
        	--env DISPLAY="QT_X11_NO_MITSHM=1" \
		--env XAUTHORITY=$XAUTHORITY \
	        --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
		--volume=$volume_tag \
		$repo_tag bash
else [ $is_no $volume_resp ]
	docker run -ti --rm \
                --net $network_tag \
                --name $container_tag \
		--env ROS_HOSTNAME=$USER \
		--env ROS_MASTER_URI=http://$USER:11311 \
		-e DISPLAY=$DISPLAY \
                $repo_tag bash
fi
