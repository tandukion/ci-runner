# Base image for MoveIt!
# Use this image since it already includes ROS and MoveIt!
FROM moveit/moveit:kinetic-release
ENV PATH=/root/.local/bin:$PATH

# install additional ROS library needed by ensenso and CPR program
RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu `lsb_release -sc` main" > /etc/apt/sources.list.d/ros-latest.list' && \
    apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654 && \
    apt-get -qq update -y

# Installing apt packages dependencies from "packages.txt"
COPY packages.txt .
RUN cat packages.txt | xargs apt-get -qq install -y

# Installing ROS packages dependencies from "rospack.txt"
COPY rospack.txt .
RUN apt-get -qq update -y
RUN while read PACKAGE; do apt-get -qq install -y ros-${ROS_DISTRO}-$PACKAGE; done < rospack.txt

# Installing python library dependencies from "requirements.txt"
COPY requirements.txt .
# need to reinstall pip for installing pygraphviz
RUN python -m pip install --upgrade pip && apt-get install -y python-pip --reinstall
RUN pip install --user -r requirements.txt
