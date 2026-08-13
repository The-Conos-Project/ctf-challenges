FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt-get install -y --no-install-recommends openssh-server file \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir -p /run/sshd

COPY challenge/ /opt/linux-trail/

RUN gzip -9 /opt/linux-trail/stage-04/archive/route.txt \
    && chmod -R a=rX /opt/linux-trail \
    && chmod 755 /opt /opt/linux-trail \
    && chmod 755 /opt/linux-trail/stage-07/tools/check-route \
    && sed -i 's/^#\?PasswordAuthentication.*/PasswordAuthentication yes/' /etc/ssh/sshd_config \
    && sed -i 's/^#\?PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config \
    && printf '%s\n' 'Linux Trail: begin with cat /opt/linux-trail/START_HERE' > /etc/motd

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D", "-e"]
