

How to build yocto root:

* take .hddimg, loop mount it
* there is a rootfs there on that fs, loop mount it
* simply tar -czvf yocto-root.tgz from the top of rootfs; use --exclude to trim
  clamav (200M) and gstreamer (30M).
