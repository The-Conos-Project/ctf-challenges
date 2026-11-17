FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
        openssh-server ca-certificates openssl \
        coreutils findutils grep gawk sed \
        tar gzip bzip2 xz-utils \
        less man-db nano vim-tiny \
        python3 xxd binutils \
        gcc libc6-dev libssl-dev \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir -p /var/run/sshd \
    && echo 'PermitRootLogin no' >> /etc/ssh/sshd_config \
    && echo 'PasswordAuthentication yes' >> /etc/ssh/sshd_config \
    && ssh-keygen -A

# Lab user: NO sudo. Unrestricted sudo is forbidden for student labs.
RUN useradd -m -s /bin/bash user \
    && echo 'user:user' | chpasswd

COPY setup.sh /tmp/setup.sh
COPY tools /tmp/tools
COPY stations /tmp/stations
COPY hackploy.json /tmp/hackploy.json
COPY README /home/user/LAB_README

RUN chmod +x /tmp/setup.sh \
    && /tmp/setup.sh \
    && apt-get purge -y gcc libc6-dev libssl-dev \
    && apt-get autoremove -y \
    && rm -rf /tmp/setup.sh /tmp/tools /tmp/stations /tmp/hackploy.json /var/lib/apt/lists/*

COPY entrypoint.sh /entrypoint.sh
RUN chmod 755 /entrypoint.sh

EXPOSE 22
CMD ["/entrypoint.sh"]
