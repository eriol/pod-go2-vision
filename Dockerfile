FROM docker.io/osrf/ros:noetic-desktop-full-focal

RUN apt update \
    && apt install -qqy ros-noetic-move-base \
        ros-noetic-joint-state-controller \
        ros-noetic-realtime-tools \
        ros-noetic-control-toolbox \
        ros-noetic-catkin \
        python3-rosdep \
        liblcm-dev \
        nlohmann-json3-dev \
        git \
        wget

RUN  apt install build-essential checkinstall zlib1g-dev libssl-dev -y \
    &&  wget https://github.com/Kitware/CMake/releases/download/v4.0.0-rc1/cmake-4.0.0-rc1.tar.gz \
    && tar -zxvf cmake-4.0.0-rc1.tar.gz \
    && cd cmake-4.0.0-rc1 \
    && ./bootstrap \
    && sudo make install
    
RUN git clone https://github.com/coin-or/qpOASES.git \
    && cd qpOASES \
    && mkdir build \
    && cd build \
    && cmake -DCMAKE_POLICY_VERSION_MINIMUM=3.5 .. \
    && make \
    && sudo make install


RUN git clone --recursive https://github.com/osqp/osqp \
    && cd osqp \
    # && git checkout 3c8daf48d036bbe0209ea7a88827d980121a8abd \
    && git checkout v1.0.0.beta1 \
    && mkdir build \
    && cd build \
    && cmake -DCMAKE_POLICY_VERSION_MINIMUM=3.5 .. \
    && sudo cmake --build . --target install \
    && sudo cp /usr/local/include/osqp/*.h .. 

RUN git clone https://github.com/robotology/osqp-eigen.git \ 
    && cd osqp-eigen \
    && git checkout v0.9.0 \
    && mkdir build \
    && cd build \
    && cmake .. \
    && make \
    && sudo make install


RUN apt install -qqy python3-catkin-tools


