{ pkgs, writeShellScriptBin }:

writeShellScriptBin "win10-vm" ''
  cat ${pkgs.OVMF.fd}/FV/OVMF_VARS.fd > /tmp/OVMF_VARS.fd
  exec ${pkgs.qemu-vfio}/bin/qemu-system-x86_64 -name guest=win10,debug-threads=on \
  -blockdev '{"driver":"file","filename":"${pkgs.OVMF.fd}/FV/OVMF_CODE.fd","node-name":"libvirt-pflash0-storage","auto-read-only":true,"discard":"unmap"}' \
  -blockdev '{"node-name":"libvirt-pflash0-format","read-only":true,"driver":"raw","file":"libvirt-pflash0-storage"}' \
  -blockdev '{"driver":"file","filename":"/tmp/OVMF_VARS.fd","node-name":"libvirt-pflash1-storage","auto-read-only":true,"discard":"unmap"}' \
  -blockdev '{"node-name":"libvirt-pflash1-format","read-only":false,"driver":"raw","file":"libvirt-pflash1-storage"}' \
  -machine pc-q35-5.1,accel=kvm,usb=off,vmport=off,dump-guest-core=off,pflash0=libvirt-pflash0-format,pflash1=libvirt-pflash1-format \
   -monitor stdio \
   -cpu host,migratable=no,topoext=on,host-cache-info=on,+invtsc,hv_time,hv_relaxed,hv_vpindex,hv_synic,hv_spinlocks=0x1fff,hv_vendor_id=ab12341234ab$,hv_vapic,-amd-stibp \
   -m 12288 \
   -mem-path /dev/hugepages1G/qemu-win10-vm -mem-prealloc \
   -smp 8,sockets=1,dies=1,cores=4,threads=2 \
   -object iothread,id=iothread1 \
   -object iothread,id=iothread2 \
   -object iothread,id=iothread3 \
   -object iothread,id=iothread4 \
   -uuid 96052919-6a83-4e9f-8e9b-628de3e27cc1 \
   -display none \
   -no-user-config \
   -nodefaults \
   -rtc base=localtime,driftfix=slew -global kvm-pit.lost_tick_policy=delay \
   -no-hpet -no-shutdown \
   -global ICH9-LPC.disable_s3=1 \
   -global ICH9-LPC.disable_s4=1 \
   -boot strict=on \
   -device pcie-root-port,port=0x10,chassis=1,id=pci.1,bus=pcie.0,multifunction=on,addr=0x2 \
   -device pcie-root-port,port=0x11,chassis=2,id=pci.2,bus=pcie.0,addr=0x2.0x1 \
   -device pcie-root-port,port=0x12,chassis=3,id=pci.3,bus=pcie.0,addr=0x2.0x2 \
   -device pcie-root-port,port=0x13,chassis=4,id=pci.4,bus=pcie.0,addr=0x2.0x3 \
   -device pcie-root-port,port=0x14,chassis=5,id=pci.5,bus=pcie.0,addr=0x2.0x4 \
   -device pcie-root-port,port=0x15,chassis=6,id=pci.6,bus=pcie.0,addr=0x2.0x5 \
   -device pcie-root-port,port=0x16,chassis=7,id=pci.7,bus=pcie.0,addr=0x2.0x6 \
   -device pcie-pci-bridge,id=pci.8,bus=pci.4,addr=0x0 \
   -device pcie-root-port,port=0x17,chassis=9,id=pci.9,bus=pcie.0,addr=0x2.0x7 \
   -device pcie-root-port,port=0x8,chassis=10,id=pci.10,bus=pcie.0,multifunction=on,addr=0x1 \
   -device pcie-root-port,port=0xa,chassis=11,id=pci.11,bus=pcie.0,addr=0x1.0x1 \
   -device pcie-root-port,port=0xa,chassis=12,id=pci.12,bus=pcie.0,addr=0x1.0x2 \
   -device pcie-root-port,port=0xb,chassis=13,id=pci.13,bus=pcie.0,addr=0x1.0x3 \
   -device pcie-root-port,port=0xc,chassis=14,id=pci.14,bus=pcie.0,addr=0x1.0x4 \
   -device pcie-root-port,port=0xd,chassis=15,id=pci.15,bus=pcie.0,addr=0x1.0x5 \
   -device pcie-root-port,port=0xe,chassis=16,id=pci.16,bus=pcie.0,addr=0x1.0x6 \
   -device pcie-root-port,port=0xf,chassis=17,id=pci.17,bus=pcie.0,addr=0x1.0x7 \
   -device pcie-root-port,port=0x18,chassis=18,id=pci.18,bus=pcie.0,multifunction=on,addr=0x3 \
   -device pcie-root-port,port=0x19,chassis=19,id=pci.19,bus=pcie.0,addr=0x3.0x1 \
   -device pcie-root-port,port=0x1a,chassis=20,id=pci.20,bus=pcie.0,addr=0x3.0x2 \
   -device pcie-root-port,port=0x1b,chassis=21,id=pci.21,bus=pcie.0,addr=0x3.0x3 \
   -device pcie-root-port,port=0x1c,chassis=22,id=pci.22,bus=pcie.0,addr=0x3.0x4 \
   -device pcie-root-port,port=0x1d,chassis=23,id=pci.23,bus=pcie.0,multifunction=on,addr=0x3.0x5 \
   -device pcie-pci-bridge,id=pci.24,bus=pci.10,addr=0x0 \
   -device ich9-usb-ehci1,id=usb -device ich9-usb-uhci1,masterbus=usb.0,firstport=0,multifunction=on -device ich9-usb-uhci2,masterbus=usb.0,firstport=2 -device ich9-usb-uhci3,masterbus=usb.0,firstport=4 \
   -device qemu-xhci,id=usb3,p2=4,p3=8 \
   -device virtio-scsi-pci,id=scsi0,bus=pci.6,addr=0x0 \
   -device virtio-serial-pci,id=virtio-serial0,bus=pci.3,addr=0x0 \
   -device ich9-intel-hda,id=sound0 \
   -device hda-output,audiodev=pa1 \
   -device hda-micro,audiodev=pa1 \
   -audiodev pa,id=pa1,server=/run/user/1000/pulse/native,out.buffer-length=4000,timer-period=1000 \
   -blockdev '{"driver":"host_device","filename":"/dev/disk/by-id/ata-HFS256G32TNF-N3A0A_MJ8BN15091150BM1Z","node-name":"libvirt-2-storage","auto-read-only":true,"discard":"unmap"}' \
   -blockdev '{"node-name":"libvirt-2-format","read-only":false,"discard":"unmap","driver":"raw","file":"libvirt-2-storage"}' \
   -device scsi-hd,bus=scsi0.0,channel=0,scsi-id=0,lun=0,device_id=drive-scsi0-0-0-0,drive=libvirt-2-format,id=scsi0-0-0-0,bootindex=2 \
   -blockdev '{"driver":"host_device","filename":"/dev/mapper/ata-ST2000DM008-2FR102_WK301C3H-part2","aio":"native","node-name":"libvirt-1-storage","cache":{"direct":true,"no-flush":false},"auto-read-only":true,"discard":"unmap"}' \
   -device scsi-hd,bus=scsi0.0,channel=0,scsi-id=0,lun=1,device_id=drive-scsi0-0-0-1,drive=libvirt-1-format,id=scsi0-0-0-1,bootindex=3 \
   -blockdev '{"node-name":"libvirt-1-format","read-only":false,"cache":{"direct":true,"no-flush":false},"driver":"raw","file":"libvirt-1-storage"}' \
   -netdev user,id=smbnet0,restrict=no,net=10.1.2.0/24,host=10.1.2.1,smb=/home/kat/shared/,smbserver=10.1.2.2 \
   -device virtio-net-pci,netdev=smbnet0,id=net1,mac=2b:c6:c4:ac:67:ba \
   -device vfio-pci,host=0000:29:00.0,id=hostdev0,bus=pci.7,addr=0x0 \
   -device vfio-pci,host=0000:29:00.1,id=hostdev1,bus=pci.9,addr=0x0 \
   -device vfio-pci,host=0000:28:00.0,id=hostdev3,bus=pci.11,addr=0x0 \
   -device vfio-pci,host=0000:2b:00.3,id=hostdev4,bus=pci.19,addr=0x0 \
   -device virtio-balloon-pci,id=balloon0,bus=pci.5,addr=0x0 \
   -chardev socket,path=/tmp/vfio-qmp,server,nowait,id=qmp0 \
   -mon chardev=qmp0,id=qmp,mode=control \
   -chardev socket,path=/tmp/vfio-qga,server,nowait,id=qga0 \
   -device virtserialport,chardev=qga0,name=org.qemu.guest_agent.0 \
   -set device.scsi0-0-0-0.rotation_rate=1 \
   -cpu host,hv_time,kvm=off,hv_vendor_id=null,-hypervisor \
   -msg timestamp=on "$@"''

# -device vfio-pci,host=0000:21:00.0,id,addr=0x0 \
# -device virtio-net-pci,netdev=hostnet0,id=net0,mac=5b:f2:eb:3c:0b:46 \
# -netdev bridge,id=hostnet0,br=br,helper=$(type -P qemu-bridge-helper) \
#  -vcpu vcpunum=0,affinity=0 \
#   -vcpu vcpunum=1,affinity=1 \
#   -vcpu vcpunum=2,affinity=2 \
#   -vcpu vcpunum=3,affinity=3 \
#   -vcpu vcpunum=4,affinity=6 \
#   -vcpu vcpunum=5,affinity=7 \
#   -vcpu vcpunum=6,affinity=8 \
#   -vcpu vcpunum=7,affinity=9 \
