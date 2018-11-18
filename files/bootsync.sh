#!/bin/sh
# put other system startup commands here, the boot process will wait until they complete.
# Use bootlocal.sh for system startup commands that can run in the background 
# and therefore not slow down the boot process.
/usr/bin/sethostname box

/etc/init.d/autoformat start

if [ -s /var/lib/boot2podman/etc/hostname ]; then
	hostname="$(cat /var/lib/boot2podman/etc/hostname)"
	/usr/bin/sethostname "$hostname"
fi

su "tc" -c "tce-load -i podman.tcz varlink.tcz resolver.tcz buildah.tcz"
/sbin/ldconfig 2>/dev/null

/usr/local/etc/init.d/varlink start
/usr/local/etc/init.d/podman start

su "tc" -c "tce-load -i openssh.tcz"
/sbin/ldconfig 2>/dev/null

if [ -d /var/lib/boot2podman/etc/ssh ]; then
	cp -p /var/lib/boot2podman/etc/ssh/* /usr/local/etc/ssh
fi
for keyType in rsa dsa ecdsa ed25519; do # pre-generate a few SSH host keys to decrease the verbosity of /usr/local/etc/init.d/openssh
	keyFile="/usr/local/etc/ssh/ssh_host_${keyType}_key"
	[ ! -f "$keyFile" ] || continue
	echo "Generating $keyFile"
	ssh-keygen -q -t "$keyType" -N '' -f "$keyFile"
	mkdir -p /var/lib/boot2podman/etc/ssh
	cp "$keyFile" /var/lib/boot2podman/etc/ssh
done
/usr/local/etc/init.d/openssh start

mkdir /root/.ssh
chmod 700 /root/.ssh
cp /home/tc/.ssh/authorized_keys /root/.ssh/
chmod 600 /root/.ssh/authorized_keys

if [ -e /var/lib/boot2podman/bootlocal.sh ]; then
	sh /var/lib/boot2podman/bootlocal.sh &
fi

/opt/bootlocal.sh &
