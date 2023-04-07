FROM ubuntu:latest

RUN apt-get update && apt-get upgrade -y
RUN apt-get -y install tini curl git net-tools && \
    apt-get -y install zsh vim openssh-server

RUN mkdir /var/run/sshd
RUN ssh-keygen -A
RUN echo 'PermitEmptyPasswords yes' >> /etc/ssh/sshd_config
RUN sed -i 's/nullok_secure/nullok/' /etc/pam.d/common-auth

RUN groupadd -g 1000 heymatch && \
    useradd --uid 1000 --gid 1000 --groups root,sudo,adm,users --create-home --password '' --shell /bin/bash heymatch && \
    echo '%sudo ALL=(ALL) ALL' >> /etc/sudoers


EXPOSE 22
# ENTRYPOINT service ssh restart
ENTRYPOINT ["/usr/bin/tini", "--"]
CMD ["/usr/sbin/sshd", "-D"]