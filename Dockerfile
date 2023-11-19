ARG DEBIAN_DISTRO=bookworm
FROM arm64v8/debian:${DEBIAN_DISTRO}

ARG URL="https://s3.ap-northeast-1.wasabisys.com/download-raw/dpkg/ros2-desktop/debian/bookworm/ros-iron-desktop-0.3.2_20231028_arm64.deb"

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
  cmake \
  curl \
  doxygen \
  git \
  gnupg \
  lsb-release \
  libacl1-dev \
  libasio-dev \
  libatlas-base-dev \
  libbluetooth-dev \
  libboost-dev \
  libboost-program-options-dev \
  libboost-python-dev \
  libbullet-dev \
  libcurlpp-dev \
  libdrm-dev \
  libeigen3-dev \
  libfreetype-dev \
  libcwiid1 \
  libcwiid-dev \
  libfmt-dev \
  libgtk-3-dev \
  libglfw3-dev \
  libgl1-mesa-dev \
  libglu1-mesa-dev \
  liblog4cxx-dev \
  liblttng-ust-dev \
  libopencv-dev \
  libpcap-dev \
  libpcl-dev \
  librange-v3-dev \
  libresource-retriever-dev \
  libsdl2-dev \
  libspnav-dev \
  libssl-dev \
  libtinyxml2-dev \
  libusb-1.0-0-dev \
  libxaw7-dev \
  libxcursor-dev \
  libxrandr-dev \
  libyaml-cpp-dev \
  mingw-w64-i686-dev \
  ninja-build \
  pciutils \
  pkg-config \
  pyqt5-dev \
  python3-argcomplete \
  python3-flake8 \
  python3-dev \
  python3-netifaces \
  python3-numpy \
  python3-pip \
  python3-rosdep2 \
  python3-setuptools \
  python3-sip \
  python3-pydot \
  python3-pyqt5.qtsvg \
  python3-pytest-cov \
  python3-jinja2 \
  python3-lark \
  python3-pyqt5 \
  qtbase5-dev \
  sip-dev \
  xterm \
  wget \
  zip && \
  rm -rf /var/lib/apt/lists/*

RUN pip install --break-system-packages \
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

RUN wget -O /tmp/ros.deb ${URL}
RUN apt install -y /tmp/ros.deb

RUN ldconfig
RUN mkdir -p /ros2_ws/src
WORKDIR /ros2_ws
