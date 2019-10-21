FROM python:2.7-slim AS compile-image

# install dependencies
RUN apt-get update
RUN apt-get install -y \
    graphviz \
    libgraphviz-dev \
    pkg-config \
    python-rosinstall \
    python-rosinstall-generator \
    python-wstool \
    build-essential

# install python library dependencies listed on requirements.txt
COPY requirements.txt .
# need to reinstall pip for installing pygraphviz
RUN python -m pip uninstall -y pip && apt-get install -y python-pip --reinstall
RUN pip install --user -r requirements.txt

# base image for ROS kinetic
FROM ros:kinetic-robot AS ros-image
COPY --from=compile-image /root/.local /root/.local

FROM moveit/moveit:kinetic-release
COPY --from=ros-image /root/.local /root/.local

# installing Ensenso driver
ADD "https://download.ensenso.com/s/ensensosdk/download?files=ensenso-sdk-2.2.65-x64.deb" ensenso.deb
RUN dpkg -i ensenso.deb

# install additional ROS library
RUN ROS_DISTRO=$(ls /opt/ros/) && \
    apt-get -qq install -y \
    ros-${ROS_DISTRO}-pcl-ros \
    ros-${ROS_DISTRO}-pcl-conversions \
    ros-${ROS_DISTRO}-image-geometry \
    ros-${ROS_DISTRO}-tf2-geometry-msgs