FROM python:2.7-slim AS compile-image

RUN apt-get update
RUN apt-get install -y \
    graphviz \
    libgraphviz-dev \
    pkg-config \
    python-rosinstall \
    python-rosinstall-generator \
    python-wstool \
    build-essential

COPY requirements.txt .
# need to reinstall pip for installing pygraphviz
RUN python -m pip uninstall -y pip && apt-get install -y python-pip --reinstall
RUN pip install --user -r requirements.txt

FROM ros:kinetic-robot AS ros-image
COPY --from=compile-image /root/.local /root/.local

# base image for MoveIt!
FROM moveit/moveit:kinetic-release
COPY --from=ros-image /root/.local /root/.local

# install additional ROS library needed by ensenso and CPR program
RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu `lsb_release -sc` main" > /etc/apt/sources.list.d/ros-latest.list' && \
    apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654 && \
    apt-get -qq update -y && \
    apt-get -qq install -y python-catkin-tools python-catkin-lint xterm \
    gnome-terminal