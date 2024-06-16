FROM quay.io/fedora/fedora-bootc:40

ARG ROLE_NAME=kahowell-environment
ARG USER=kahowell
ARG CHEZMOI_REPO=kahowell
ARG UID=1000
ARG EMAIL=kevin@example.com

RUN dnf install -y ansible
COPY . /etc/ansible/roles/${ROLE_NAME}

# system level stuff
RUN ansible-playbook /etc/ansible/roles/${ROLE_NAME}/provision.yml -t desktop
RUN ansible-playbook /etc/ansible/roles/${ROLE_NAME}/provision.yml -t packages
RUN ansible-playbook /etc/ansible/roles/${ROLE_NAME}/provision.yml -t flatpaks

# user-specific stuff
RUN useradd -u 1000 -m ${USER} -G wheel && \
    echo "${USER} ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/bootc-build-nopasswd
USER ${UID}
RUN ansible-playbook /etc/ansible/roles/${ROLE_NAME}/provision.yml -t brew
RUN EMAIL=${EMAIL} /home/linuxbrew/.linuxbrew/bin/chezmoi init --apply ${CHEZMOI_REPO}
USER 0
RUN rm -f /etc/sudoers.d/bootc-build-nopasswd
