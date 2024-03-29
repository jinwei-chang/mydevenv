FROM ubuntu:jammy

# install packages
COPY ./setup/sources.list /etc/apt/
RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y tini curl git net-tools sudo g++ && \
    apt-get install -y zsh vim openssh-server make gdb

# config ssh server
RUN mkdir /var/run/sshd
RUN ssh-keygen -A
RUN echo 'PermitEmptyPasswords yes' >> /etc/ssh/sshd_config
RUN sed -i 's/nullok_secure/nullok/' /etc/pam.d/common-auth

# config user
RUN groupadd -g 1000 heymatch && \
    useradd --uid 1000 --gid 1000 --groups root,sudo,adm,users --create-home --password '' --shell /bin/zsh heymatch && \
    echo '%sudo ALL=(ALL) ALL' >> /etc/sudoers
COPY ./setup /home/heymatch/setup/
RUN mkdir /home/heymatch/workspace && chown heymatch:heymatch -R /home/heymatch/workspace && \
    chown -R heymatch:heymatch  /home/heymatch/setup/

# config services
EXPOSE 22
# ENTRYPOINT service ssh restart
ENTRYPOINT ["/usr/bin/tini", "--"]
CMD ["/usr/sbin/sshd", "-D"]