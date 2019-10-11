FROM python:2.7-slim AS compile-image

RUN apt-get update
RUN apt-get install -y \
    graphviz \
    libgraphviz-dev \
    pkg-config \
    python-rosinstall-generator \
    python-wstool \
    build-essential

COPY requirements.txt .
# need to reinstall pip for installing pygraphviz
RUN python -m pip uninstall -y pip && apt-get install -y python-pip --reinstall
RUN pip install --user -r requirements.txt

FROM ros:kinetic-robot
COPY --from=compile-image /root/.local /root/.local
