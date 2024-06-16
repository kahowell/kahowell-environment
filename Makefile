.PHONY: build-image
# NOTE: need to build with additional privileges and /proc/sys/user in order to install flatpaks
build:
	podman build -v /proc/sys/user:/proc/sys/user --security-opt label=disable . -t kahowell-environment:latest

.PHONY: update-image
update:
	podman build -v /proc/sys/user:/proc/sys/user --security-opt label=disable . -t kahowell-environment:latest
