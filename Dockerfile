FROM --platform=amd64 osrf/ros:noetic-desktop-full

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    build-essential \
    cmake \
    git \
    libssl-dev \
    libusb-1.0-0-dev \
    pkg-config \
    libgtk-3-dev \
    libglfw3-dev \
    libgl1-mesa-dev \
    libglu1-mesa-dev \
    curl \
    python3 \
    python3-dev \
    ca-certificates \
    net-tools \
    iputils-ping \ 
    nano \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /root

# COPY Shared/lcm-v1.4.0.tar.gz /tmp/
RUN curl -L -o lcm-v1.4.0.tar.gz https://github.com/lcm-proj/lcm/archive/refs/tags/v1.4.0.tar.gz


RUN tar -xzvf lcm-v1.4.0.tar.gz \
    && rm lcm-v1.4.0.tar.gz \
    && cd lcm-1.4.0 \
    && mkdir build \
    && cd build \
    && cmake .. \ 
    && make install


WORKDIR /root

# COPY Shared/unitree_legged_sdk-3.2.tar.gz /root/
RUN curl -L -o unitree_legged_sdk-3.2.tar.gz https://github.com/unitreerobotics/unitree_legged_sdk/archive/refs/tags/v3.2.tar.gz

RUN tar -xzvf unitree_legged_sdk-3.2.tar.gz \
    && rm unitree_legged_sdk-3.2.tar.gz \
    && mv unitree_legged_sdk-3.2 unitree_legged_sdk \ 
    && cd unitree_legged_sdk \
    && mkdir build \
    && cd build \
    && cmake .. \
    && make

ENV UNITREE_SDK_VERSION=3_2
ENV UNITREE_LEGGED_SDK_PATH=/root/unitree_legged_sdk
ENV UNITREE_PLATFORM=amd64
#aded here
ENV LD_LIBRARY_PATH=/path/to/your/libraries:$LD_LIBRARY_PATH

WORKDIR /root/catkin_ws/src

# COPY Shared/unitree_ros_to_real.tar.gz /root/catkin_ws/src
RUN curl -L -o unitree_ros_to_real.tar.gz https://github.com/unitreerobotics/unitree_ros_to_real/archive/refs/tags/v3.2.1.tar.gz

RUN tar -xzvf unitree_ros_to_real.tar.gz \
    && rm unitree_ros_to_real.tar.gz \
    && mv unitree_ros_to_real-3.2.1 unitree_ros_to_real

RUN cd ~/catkin_ws \
    && /bin/bash -c "source /opt/ros/noetic/setup.bash; catkin_make"


CMD ["bash"]