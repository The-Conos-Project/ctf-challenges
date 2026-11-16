FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
        openssh-server sudo ca-certificates openssl \
        coreutils findutils grep gawk sed \
        less man-db nano vim-tiny \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir -p /var/run/sshd \
    && echo 'PermitRootLogin no' >> /etc/ssh/sshd_config \
    && echo 'PasswordAuthentication yes' >> /etc/ssh/sshd_config \
    && ssh-keygen -A

RUN useradd -m -s /bin/bash user \
    && echo 'user:user' | chpasswd \
    && echo 'user ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/user

COPY setup.sh /tmp/setup.sh
COPY lib /tmp/lib
COPY stations /tmp/stations
RUN chmod +x /tmp/setup.sh /tmp/lib/ask.sh \
    && /tmp/setup.sh \
    && rm -rf /tmp/setup.sh /tmp/lib /tmp/stations

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
