FROM ubuntu:20.10

WORKDIR /workspaces

RUN apt-get update \
  && apt-get install -y \
    git \
    python \
    pkg-config \
    wget \
    curl

RUN git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git
ENV PATH=/workspaces/depot_tools:$PATH

RUN fetch v8
RUN cd v8 \
  && gclient sync \
  && tools/dev/gm.py x64.release
