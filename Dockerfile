FROM debian:10 AS builder

WORKDIR /workspaces

RUN apt-get update \
  && apt-get install -y \
    git \
    python \
    python3 \
    pkg-config \
    wget \
    curl

RUN git clone --depth=1 https://chromium.googlesource.com/chromium/tools/depot_tools.git
ENV PATH=/workspaces/depot_tools:$PATH

RUN fetch --no-history v8
RUN cd v8 \
  && gclient sync \
  && tools/dev/gm.py x64.release


FROM debian:10-slim

WORKDIR /v8

COPY --from=builder /workspaces/v8/out/x64.release/d8 .
COPY --from=builder /workspaces/v8/out/x64.release/snapshot_blob.bin .

ENTRYPOINT [ "./d8" ]
