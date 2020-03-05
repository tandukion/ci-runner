# base image for MoveIt!
FROM moveit/moveit:kinetic-release
#COPY --from=ros-image /root/.local /root/.local
ENV PATH=/root/.local/bin:$PATH

# install additional ROS library needed by ensenso and CPR program
RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu `lsb_release -sc` main" > /etc/apt/sources.list.d/ros-latest.list' && \
    apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654 && \
    apt-get -qq update -y && \
    apt-get -qq install -y python-catkin-tools python-catkin-lint \
    graphviz \
    libgraphviz-dev \
    pkg-config \
    python-rosinstall \
    python-rosinstall-generator \
    python-wstool \
    build-essential \
    python-pip

COPY requirements.txt .
# need to reinstall pip for installing pygraphviz
RUN python -m pip install --upgrade pip && apt-get install -y python-pip --reinstall
RUN pip install --user -r requirements.txt
