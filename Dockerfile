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


RUN git clone --recursive -b v0.6.3 https://github.com/osqp/osqp \
    && cd osqp \
    # && git checkout 3c8daf48d036bbe0209ea7a88827d980121a8abd \
    # && git checkout v0.6.3 \
    && mkdir build \
    && cd build \
    && cmake -DCMAKE_POLICY_VERSION_MINIMUM=3.5 .. \
    && sudo cmake --build . --target install
    #&& sudo cp /usr/local/include/osqp/*.h .. 

RUN git clone https://github.com/robotology/osqp-eigen.git \ 
    && cd osqp-eigen \
    && git checkout v0.9.0 \
    && mkdir build \
    && cd build \
    && cmake .. \
    && make \
    && sudo make install


RUN apt install -qqy python3-catkin-tools

RUN wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/cuda-keyring_1.1-1_all.deb \
    && sudo dpkg -i cuda-keyring_1.1-1_all.deb \
    && sudo apt-get update \
    && sudo apt-get -y install cuda-toolkit-12-8


RUN apt-get install -y python3-pip && pip install pybind11 
# Clone and install GeNN
RUN git clone -b 5.1.0 https://github.com/genn-team/genn.git /opt/genn \
    && cd /opt/genn \
    && make DYNAMIC=1 LIBRARY_DIRECTORY=$(pwd)/pygenn/genn_wrapper/ \
    && python3 setup.py develop 
RUN echo 'export PATH="$PATH:/opt/genn/bin"' >> /etc/profile.d/genn.sh \
    && echo 'export PYTHONPATH="$PYTHONPATH:/opt/genn"' >> /etc/profile.d/genn.sh \
    && echo 'export CUDA_PATH=/usr/local/cuda' >> /etc/profile.d/genn.sh

# Ensure the environment variables are loaded in every shell
RUN echo "source /opt/ros/noetic/setup.bash" >> /etc/profile.d/ros.sh

# Set the default shell to bash
SHELL ["/bin/bash", "-c"]

# Run bash by default
CMD ["bash"]

# RUN git clone -b 5.1.0 https://github.com/genn-team/genn.git $HOME/genn \
#     && echo "export PATH=$PATH:$HOME/genn/bin" >> $HOME/.bash_profile \
#     && echo "export CUDA_PATH=/usr/local/cuda" >> $HOME/.bash_profile

# RUN apt-get install -y python3-pip && pip install pybind11 

# RUN cd $HOME/genn \ 
#     && make DYNAMIC=1 LIBRARY_DIRECTORY=`pwd`/pygenn/genn_wrapper/

# RUN cd $HOME/genn \
#     && python3 setup.py develop --user

# RUN echo "source /opt/ros/noetic/setup.bash" >> $HOME/.bash_profile 

RUN sudo apt-get install -y python3-tk

