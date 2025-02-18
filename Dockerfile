FROM alpine:3.21

RUN apk add \
    --repository=http://dl-cdn.alpinelinux.org/alpine/edge/community/ \
    --no-cache \
    coreutils \
    util-linux \
    shadow \
    curl \
    wget \
    rclone \
    rsync \
    ca-certificates \
    tzdata \
    bash \
    fish \
    git \
    micro \
    lsd \
    openssh \
    sudo \
    mkvtoolnix \
    ffmpeg \
    go

# Support sudo.
RUN useradd -m -s /usr/bin/fish -u 99 -g 100 user && echo "user:1" | chpasswd && \
    echo "user ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# XDG_RUNTIME_DIR needs 700 permission.
ENV XDG_RUNTIME_DIR=/home/user/runtime-dir
WORKDIR /home/user

USER user
RUN go install github.com/charleshuang3/subget@latest

ENTRYPOINT [ "tail", "-f", "/dev/null" ]
