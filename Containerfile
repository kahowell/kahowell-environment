FROM quay.io/fedora/fedora-bootc:41

ARG ROLE_NAME=kahowell-environment
ARG CHEZMOI_REPO=kahowell
ARG EMAIL=kevin@example.com

RUN mkdir -p /var/lib/alternatives
RUN dnf install -y ansible
COPY . /etc/ansible/roles/${ROLE_NAME}

# system level stuff
RUN ansible-playbook /etc/ansible/roles/${ROLE_NAME}/provision.yml -t desktop
RUN ansible-playbook /etc/ansible/roles/${ROLE_NAME}/provision.yml -t packages
RUN ansible-playbook /etc/ansible/roles/${ROLE_NAME}/provision.yml -t flatpaks
RUN ansible-playbook /etc/ansible/roles/${ROLE_NAME}/provision.yml -t misc-software

# linuxbrew user to install brew packages
RUN useradd -m -s /bin/false -r linuxbrew
RUN ln -s /opt/linuxbrew /var/home/linuxbrew
RUN echo "L /var/home/linuxbrew - - - - /opt/linuxbrew" > /etc/tmpfiles.d/linuxbrew.conf
RUN ansible-playbook /etc/ansible/roles/${ROLE_NAME}/provision.yml -t brew
RUN EMAIL=${EMAIL} /home/linuxbrew/.linuxbrew/bin/chezmoi init --apply ${CHEZMOI_REPO} --destination /etc/skel
