.PHONY: build
# NOTE: need to build with additional privileges and /proc/sys/user in order to install flatpaks
build:
	sudo podman build -v /proc/sys/user:/proc/sys/user --security-opt label=disable . -t kahowell-environment:latest

.PHONY: update
update:
	sudo podman build --no-cache -v /proc/sys/user:/proc/sys/user --security-opt label=disable -f Containerfile.update . -t kahowell-environment:latest

qcow2:
	./bootc-image-builder.sh --rootfs ext4 --local --type qcow2 localhost/kahowell-environment:latest

iso:
	./bootc-image-builder.sh --rootfs ext4 --local --type iso localhost/kahowell-environment:latest
