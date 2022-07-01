FROM pgrouting/pgrouting:13-3.1-3.2.0

LABEL maintainer="pgRouting Project - https://pgrouting.net"

ENV VRPROUTING_VERSION 0.3.0
ENV VRPROUTING_SHA256 73749cd96600bbccf04ef562ad8aea46ef69314fd699e8e7cb9ad1b0bc5e41de

RUN set -ex \
    && apt update \
    && apt install -y --no-install-recommends \
      build-essential \
      ca-certificates \
      cmake \
      wget \
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
    && wget -O vrprouting.tar.gz "https://github.com/pgRouting/vrprouting/archive/v${VRPROUTING_VERSION}.tar.gz" \
    && echo "$VRPROUTING_SHA256 *vrprouting.tar.gz" | sha256sum -c - \
    && mkdir -p /usr/src/vrprouting \
    && tar \
      --extract \
      --file vrprouting.tar.gz \
      --directory /usr/src/vrprouting \
      --strip-components 1 \
    && rm vrprouting.tar.gz \
    && cd /usr/src/vrprouting \
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
      wget \
      libpq-dev \
      libboost-graph-dev \
      postgresql-server-dev-${PG_MAJOR} \
      libasio-dev \
      libssl-dev \
    && rm -rf /var/lib/apt/lists/*
