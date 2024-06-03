IMAGE := opensense.qcow2
IMAGE_SIZE := 16G
NIC := user,id=qe0,hostfwd=tcp::60080-:80,hostfwd=tcp::60022-:22

run:
	qemu-system-x86_64 \
		-enable-kvm \
		-nic ${NIC} \
		-drive file=${IMAGE},media=disk,if=virtio \
		-m 2048

run-install:
	qemu-system-x86_64 \
		-enable-kvm \
		-nic ${NIC} \
		-drive file=${IMAGE},media=disk,if=virtio \
		-m 2048 \
		-usb *.img

mk-drive:
	qemu-img \
		create \
		-f qcow2 \
		"${IMAGE}" \
		"${IMAGE_SIZE}"
