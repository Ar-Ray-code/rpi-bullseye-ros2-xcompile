FROM arm64v8/debian:bullseye

ENV TZ=Asia/Tokyo
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get upgrade -y && apt install locales -y && \
    locale-gen en_US en_US.UTF-8 && \
    apt -y clean && \
    rm -rf /var/lib/apt/lists/*
ENV LANG=en_US.UTF-8

# Install ros2 dependencies
RUN apt-get update && \
	apt-get install -y \
	bison \
  build-essential \
  curl \
  cmake \
  doxygen \
  git \
  gnupg \
	libacl1-dev \
  libasio-dev \
  libbullet-dev \
  libeigen3-dev \
  libfreetype-dev \
  liblog4cxx-dev \
  libopencv-dev \	
  libresource-retriever-dev \
  libsdl2-dev \
  libtinyxml2-dev \
  libxaw7-dev 
  libxcursor-dev \
  libxrandr-dev \
	lsb-release \
  mingw-w64-i686-dev \
  pciutils \
  pyqt5-dev \
  python3-flake8 \
  python3-lark \
  python3-netifaces \
  python3-numpy \
	python3-pip \
	python3-pydot \
  python3-pyqt5 \
  python3-pyqt5.qtsvg \
  python3-pytest-cov \
  python3-rosdep2 \
	python3-setuptools \
	python3-sip \
	qtbase5-dev \
	sip-dev \
  xterm \
	wget \
  zip

RUN pip install --upgrade pip

RUN pip install \
  colcon-common-extensions \
	flake8-blind-except \
	flake8-builtins \
	flake8-class-newline \
	flake8-comprehensions \
	flake8-deprecated \
	flake8-docstrings \
	flake8-import-order \
	flake8-quotes \
  importlib-metadata \
	importlib-resources \
  ipaddress \
  lark-parser \
	pytest-repeat \
	pytest-rerunfailures \
	pytest \
	setuptools \
  vcstool
  

# additional packages
RUN apt update && \
    apt install -y \
    libatlas-base-dev \
    libbluetooth-dev \
    libboost-python-dev \
    libcurlpp-dev \
    libcwiid1 \
    libcwiid-dev \
    libspnav-dev \
    libusb-1.0-0-dev
    libyaml-cpp-dev \
    ntpdate \
    python3-netifaces \
    python3-psutil \
    
# Downloading ros-humble and unzip
RUN wget https://github.com/Ar-Ray-code/rpi-bullseye-ros2/releases/download/ros2-0.2.0/humble-aarch64.zip && \
	mkdir -p /opt/ros && \
	unzip humble-aarch64.zip -d /opt/ros && \
	rm humble-aarch64.zip

RUN mkdir -p /ros2_ws/src
WORKDIR /ros2_ws