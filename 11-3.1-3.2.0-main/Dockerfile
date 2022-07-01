FROM pgrouting/pgrouting:11-3.1-3.2.0

LABEL maintainer="pgRouting Project - https://pgrouting.net"

ENV VRPROUTING_VERSION main
ENV VRPROUTING_GIT_HASH 0de911e470d38ea629faac49d9360c8b0e03d2e8

RUN set -ex \
    && apt update \
    && apt install -y --no-install-recommends \
      build-essential \
      ca-certificates \
      cmake \
      git \
      libboost-graph-dev \
      libpq-dev \
      postgresql-server-dev-${PG_MAJOR} \
      # vroom dependency
      libasio-dev \
      libglpk-dev \
      libssl-dev \
    # build vroom
    && wget -O vroom.tar.gz "https://github.com/VROOM-Project/vroom/archive/v1.11.0.tar.gz" \
    && mkdir -p /usr/src/vroom \
    && tar \
      --extract \
      --file vroom.tar.gz \
      --directory /usr/src/vroom \
      --strip-components 1 \
    && rm vroom.tar.gz \
    && cd /usr/src/vroom/src \
    && sed -i 's/CXXFLAGS = /CXXFLAGS = -fPIC /' makefile \
    && make \
    # build vrprouting
    && mkdir -p /usr/src/vrprouting \
    && cd /usr/src/vrprouting \
    && git init \
    && git remote add origin https://github.com/pgRouting/vrprouting.git \
    && git fetch --depth 1 origin :${VRPROUTING_GIT_HASH} \
    && git reset --hard FETCH_HEAD \
    && mkdir build \
    && cd build \
    && cmake -DVROOM_INSTALL_PATH=/usr/src/vroom .. \
    && make \
    && make install \
    && cd / \
    && rm -rf /usr/src/vrprouting \
    && rm -rf /usr/src/vroom \
    && apt purge -y --autoremove \
      build-essential \
      cmake \
      git \
      libpq-dev \
      libboost-graph-dev \
      postgresql-server-dev-${PG_MAJOR} \
      libasio-dev \
      libssl-dev \
    && rm -rf /var/lib/apt/lists/*
