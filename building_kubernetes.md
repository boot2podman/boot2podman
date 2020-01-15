# kubernetes

We run a lightweight [Kubernetes](https://kubernetes.io/) with **cri-o** and **k3s** -

instead of **containerd** and **kubeadm**, kubernetes (k8s).

## Prerequisites

First, install and set up [go](building_go.md).

``` console
$ tce-load -i go.tcz
$ tce-load -wi compiletc
```

``` sh
export GOROOT=/usr/local/go
export PATH=$GOROOT/bin:$PATH
export GOPATH=~/go
export PATH=$GOPATH/bin:$PATH
```

### cri-o

CRI-O - OCI-based implementation of Kubernetes Container Runtime Interface

https://cri-o.io/

Have to do some patching, because of the hard-coded path locations.

``` console
$ tce-load -wi libseccomp-dev glib2-dev

$ go get -d github.com/cri-o/cri-o
$ cd $GOPATH/src/github.com/cri-o/cri-o
$ sed -e 's|"/etc/cni|"/usr/local/etc/cni|' -i lib/config/config_unix.go
$ sed -e 's|"/opt/cni/bin|"/usr/local/lib/cni|' -i lib/config/config_unix.go
$ sed -e 's|"/etc/crio|"/usr/local/etc/crio|' -i lib/config/config_unix.go
$ make binaries
$ sudo install -D -m 755 bin/crio /usr/local/bin/crio
$ sudo install -D -m 755 bin/pinns /usr/local/bin/pinns
$ make crio.conf
$ sudo install -D -m 644 crio.conf /usr/local/share/crio/crio.conf
$ sudo install -D -m 644 crictl.yaml /usr/local/share/crio/crictl.yaml
$ sudo install -D -m 644 seccomp.json /usr/local/etc/crio/seccomp.json
$ cd -
```

The _confdir_ path is also hard-coded, so we install the samples in _datadir_.

Special configuration for boot2podman, using a ramdisk and no libexec:

/etc/crio.conf
``` toml
# If true, the runtime will not use pivot_root, but instead use MS_MOVE.
no_pivot = true

# Path to the conmon binary, used for monitoring the OCI runtime.
conmon = "/usr/local/lib/crio/conmon"
```

You will need to give the runtime endpoint as a parameter or in config:

`sudo crictl --runtime-endpoint unix:///var/run/crio/crio.sock`

/etc/crictl.yaml
``` yaml
runtime-endpoint: unix:///var/run/crio/crio.sock
```

### runc

We already built this with [podman](building_podman.md).

### cni

We already built this with [podman](building_podman.md).

## Build and Run Dependencies

### Build

"k3s - Kubernetes, but small and simple" (`k8s - 5 changes = k3s`)

https://k3s.io/

> k3s is intended to be a fully compliant Kubernetes distribution with the following changes:
>
> 1. Legacy, alpha, non-default features are removed. Hopefully, you shouldn't notice the
>    stuff that has been removed.
> 2. Removed most in-tree plugins (cloud providers and storage plugins) which can be replaced
>    with out of tree addons.
> 3. Add sqlite3 as the default storage mechanism. etcd3 is still available, but not the default.
> 4. Wrapped in simple launcher that handles a lot of the complexity of TLS and options.
> 5. Minimal to no OS dependencies (just a sane kernel and cgroup mounts needed).

We build k3s _without_ containerd/ctr, since we aim to run it with crio.

``` console
$ tce-load -wi libseccomp-dev sqlite3-dev

$ #go get -d github.com/rancher/k3s
$ # shallow clone to avoid k8s history:
$ mkdir -p `dirname $GOPATH/src/github.com/rancher/k3s`
$ git clone --depth 1 https://github.com/rancher/k3s $GOPATH/src/github.com/rancher/k3s
$ cd $GOPATH/src/github.com/rancher/k3s
$ cd k3s
$ go build -tags "libsqlite3 seccomp no_btrfs netgo osusergo" -ldflags "-w -s" -o k3s ./cmd/server/main.go
$ sudo install -D -m 755 k3s /usr/local/bin/k3s
$ cd -
```

The k3s program is actually a multi-purpose binary, similar to busybox:

``` sh
cd /usr/local/bin
sudo ln -s k3s k3s-server
sudo ln -s k3s k3s-agent
sudo ln -s k3s kubectl
sudo ln -s k3s crictl
cd -
```

Since we are already using squashfs, we don't need the launcher binary.

**Note**: "server" is run on the master, and "agent" is run on the [minion](https://github.com/kubernetes/kubernetes/issues/1111)(s).

### Runtime

Need the same cgroups and programs as already done for [podman](building_podman.md#Runtime).

``` console
$ tce-load -wi libseccomp glib2 gpgme sqlite3
$ tce-load -i cni-plugins.tcz runc.tcz crio.tcz k3s.tcz
```

Start the `crio` runtime daemon, and then the kubernetes apiserver:

``` console
$ sudo -b crio
$ sudo -b k3s server --container-runtime-endpoint /var/run/crio/crio.sock
```

Now use the client programs (`crictl` and `kubectl`), to talk to them:

``` console
$ sudo crictl pods
$ sudo kubectl help
```

**Note**: podman and crio/crictl share images, but they do not share pods.

## Deployment

The following are deployed by default:

* CoreDNS (`coredns`, 40M images)
* Traefik (`traefik`, 70M images)
* Service load balancer (`servicelb`, 90M images)

To cut down on the image sizes, these can be disabled with `--no-deploy`.

``` sh
sudo -b k3s server --container-runtime-endpoint /var/run/crio/crio.sock \
                   --no-deploy traefik --no-deploy servicelb
```

Airgapped images (.tar) are put in `/var/lib/rancher/k3s/agent/images/`

They are preloaded automatically for containerd, manually for other runtimes.

``` sh
# when not using the launcher binary, the images are found elsewhere
find /usr/local/share/k3s/ -type f | xargs -n 1 sudo podman load -i
```

Normally this (starting and loading images ) is done by the bundled init script:

``` console
$ sudo /usr/local/etc/init.d/k3s start
```

## Remote Access

### Joining nodes

When the server starts it creates a file `/var/lib/rancher/k3s/server/node-token`.
Use the contents of that file as `NODE_TOKEN` and then run the agent as follows

    k3s agent --server https://myserver:6443 --token ${NODE_TOKEN}

That's it.

See <https://github.com/rancher/k3s/blob/master/README.md>

### Accessing cluster from outside

Copy `/etc/rancher/k3s/k3s.yaml` on your machine located outside the cluster as
`~/.kube/config`. Then replace "localhost" with the IP or name of your k3s server.

`kubectl` can now manage your k3s cluster.

See <https://kubernetes.io/docs/tasks/tools/install-kubectl/>


### Certificates

By default the server will generate certificates for the primary interface `eth0`:

`Unable to connect to the server: x509: certificate is valid for 127.0.0.1, 10.0.2.15, not 192.168.99.100`

To also include the secondary interface `eth1` to access remotely over the IP:

`--tls-san 192.168.99.100`
