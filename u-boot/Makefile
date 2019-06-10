MKIMAGE=~/w/u-boot-xlnx/tools/mkimage

all: bootrd.img bootsd.img

clean:
	rm -f *.img

bootrd.img: bootrd.imgs
	$(MKIMAGE) -T script -C none -n 'boot with initrd' -d bootrd.imgs bootrd.img

bootsd.img: bootsd.imgs
	$(MKIMAGE) -T script -C none -n 'boot with initrd' -d bootsd.imgs bootsd.img

uarm_ramdisk.image.gz: arm_ramdisk.image.gz
	$(MKIMAGE) -A arm -T ramdisk -C gzip -d $< $@
