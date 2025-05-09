FROM quay.io/fedora/fedora-bootc:43

RUN dnf update -y
RUN mkdir -p /var/lib/alternatives
RUN dnf install -y ansible
COPY . /etc/ansible/roles/kahowell-environment

# system level stuff
RUN ansible-playbook /etc/ansible/roles/kahowell-environment/provision.yml -t desktop,packages,flatpaks,brew,misc-software,global-config

ARG CHEZMOI_REPO=kahowell
ARG EMAIL=kevin@example.com
RUN EMAIL=${EMAIL} /home/linuxbrew/.linuxbrew/bin/chezmoi init --apply ${CHEZMOI_REPO} --destination /etc/skel
