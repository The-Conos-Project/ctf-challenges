FROM ubuntu:24.04
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
        openssh-server ca-certificates openssl \
        gcc libc6-dev libssl-dev \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir -p /var/run/sshd \
    && echo 'PermitRootLogin no' >> /etc/ssh/sshd_config \
    && echo 'PasswordAuthentication yes' >> /etc/ssh/sshd_config \
    && ssh-keygen -A

# NEVER add: echo 'user ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/user
RUN useradd -m -s /bin/bash user \
    && echo 'user:user' | chpasswd

COPY setup.sh /tmp/setup.sh
RUN chmod +x /tmp/setup.sh && /tmp/setup.sh \
    && apt-get purge -y gcc libc6-dev libssl-dev \
    && apt-get autoremove -y \
    && rm -rf /tmp/setup.sh /var/lib/apt/lists/*

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
