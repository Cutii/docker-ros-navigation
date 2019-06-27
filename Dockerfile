FROM ros:melodic-ros-core-stretch

# Update Ubuntu Software repository
RUN apt-get update

# Replace shell with bash
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

# Install packages
# -----------------
RUN apt-get update && apt-get install -y --no-install-recommends \
    # General dependencies \
    python-rosinstall \
    python-rosinstall-generator \
    python-wstool \
    build-essential \
    dirmngr \
    gcc g++   \
    ros-melodic-urdf \
    # rosdep and catkin dependencies
    python-wstool \
    python-rosdep \
    ninja-build \
    # other ros dep (todo : check if needed) \
    ros-melodic-image-geometry \
    ros-melodic-rviz \
    ros-melodic-pcl-conversions \
    ros-melodic-tf2-eigen \
    ros-melodic-tf2-sensor-msgs  \
    ros-melodic-joy \
    ros-melodic-tf2-geometry-msgs \
    ros-melodic-move-base-msgs\
    ros-melodic-rotate-recovery \
    ros-melodic-amcl \
    ros-melodic-robot-localization \
    # Cartographer dependencies \
    libgoogle-glog-dev \
    liblua5.3-dev \
    python3-sphinx  \
    python-cairo \
    ninja-build \
    libceres-dev \
    libprotobuf-dev \
    protobuf-compiler \
    libprotoc-dev \
    cmake \
    g++ \
    git \
    google-mock \
    libboost-all-dev \
    libcairo2-dev \
    libgflags-dev \
    libgoogle-glog-dev \
    liblua5.2-dev \
    libsuitesparse-dev \
    ninja-build \
    libeigen3-dev  \
    clang \ 
    libcurl4-openssl-dev \
    # Global ROS dependencies \
    ros-melodic-teb-local-planner \
    ros-melodic-rgbd-launch \
    # Map Server dependencies \
    libbullet-dev \
    libsdl1.2-dev \
    libsdl-image1.2-dev \
    # Realsense S\DK dep \
    wget \
    git \
    libssl-dev \
    libusb-1.0-0-dev \
    pkg-config \
    libgtk-3-dev \
    libudev-dev \
    libglfw3-dev \
    # Install rust/cargo/cbindgen \
    curl \ 
    && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN curl https://sh.rustup.rs -sSf | bash -s -- -y   
RUN source $HOME/.cargo/env \
    && cargo install --force cbindgen 

# Install protobuf 3
# -----------------
RUN git clone https://github.com/google/protobuf.git \
    && cd protobuf \
    && git checkout tags/v3.4.1 \
    && mkdir build \
    && cd build \
    && cmake -G Ninja -DCMAKE_POSITION_INDEPENDENT_CODE=ON -DCMAKE_BUILD_TYPE=Release -Dprotobuf_BUILD_TESTS=OFF ../cmake \
    && ninja \
    && ninja install 

# Install realsense SDK
# -----------------
RUN wget https://github.com/IntelRealSense/librealsense/archive/v2.16.0.tar.gz \
    && tar -xzf v2.16.0.tar.gz \
    && cd librealsense-2.16.0 \
    && mkdir build && cd build \
    && cmake .. -DCMAKE_BUILD_TYPE=Release \
    && make -j 3 \
    && make install 