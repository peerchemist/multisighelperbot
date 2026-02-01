# Stage 1: Build the Dart Application
FROM dart:stable AS build

# Resolve app dependencies.
WORKDIR /src
COPY pubspec.* ./
RUN dart pub get

# Copy app source code and AOT compile it.
COPY . .
# Ensure packages are still up-to-date if anything has changed
RUN dart pub get --offline
RUN dart compile exe bin/multisighelper.dart -o bin/multisighelper

# Stage 2: Build libsecp256k1 v0.5.0 from Archive
FROM debian:bookworm-slim AS libbuild
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    autoconf \
    automake \
    libtool \
    pkg-config \
    ca-certificates \
    wget \
    tar && \
    rm -rf /var/lib/apt/lists/*
WORKDIR /tmp
RUN wget https://github.com/bitcoin-core/secp256k1/archive/refs/tags/v0.5.0.tar.gz && \
    tar -xzf v0.5.0.tar.gz
WORKDIR /tmp/secp256k1-0.5.0
RUN ./autogen.sh && \
    ./configure --prefix=/usr/local --enable-module-recovery && \
    make -j$(nproc) && \
    make install

# Stage 3: Create the Final Lightweight Image
FROM debian:bookworm-slim
RUN useradd -m -U -s /usr/sbin/nologin helperbot

# Copy the compiled Dart application
COPY --from=build /src/bin/multisighelper /home/helperbot/bin/

# Copy the compiled libsecp256k1 shared library from the libbuild stage
COPY --from=libbuild /usr/local/lib/libsecp256k1.so* /usr/local/lib/
RUN if [ ! -e /usr/local/lib/libsecp256k1.so ]; then \
      target=$(ls -1 /usr/local/lib/libsecp256k1.so.* | head -n1) && \
      ln -s "$target" /usr/local/lib/libsecp256k1.so; \
    fi && \
    ldconfig
ENV LD_LIBRARY_PATH=/usr/local/lib

# Ensure helperbot owns its files.
RUN chown -R helperbot:helperbot /home/helperbot

USER helperbot
CMD ["/home/helperbot/bin/multisighelper"]
