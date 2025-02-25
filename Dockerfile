FROM docker.io/osrf/ros:noetic-desktop-full-focal

RUN apt update \
    && apt install -qqy ros-noetic-move-base \
        ros-noetic-joint-state-controller \
        ros-noetic-realtime-tools \
        ros-noetic-control-toolbox \
        ros-noetic-catkin \
        python3-rosdep \
        liblcm-dev \
        nlohmann-json3-dev


