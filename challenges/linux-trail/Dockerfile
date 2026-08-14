FROM ubuntu:22.04
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y openssh-server file curl netcat-openbsd procps tar python3 less && rm -rf /var/lib/apt/lists/*
RUN mkdir -p /var/run/sshd /run/sshd
RUN sed -i 's/^#\?PasswordAuthentication.*/PasswordAuthentication yes/' /etc/ssh/sshd_config
RUN sed -i 's/^#\?PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config
RUN sed -i 's/^#\?ChallengeResponseAuthentication.*/ChallengeResponseAuthentication no/' /etc/ssh/sshd_config
RUN sed -i 's/^#\?UsePAM.*/UsePAM no/' /etc/ssh/sshd_config
RUN ssh-keygen -A && sshd -t
COPY setup.sh /usr/local/bin/setup.sh
RUN chmod +x /usr/local/bin/setup.sh
EXPOSE 22
CMD ["/bin/sh", "-c", "/usr/local/bin/setup.sh && echo 'setup complete' && exec /usr/sbin/sshd -D -e"]
