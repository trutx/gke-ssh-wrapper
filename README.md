# gke-ssh-wrapper

SSH wrapper to connect to GKE nodes

## Motivation

There's probably other use cases but mine is simple: I grew tired of having to get GKE nodes' IPs to `ssh` into them.

`kubectl get nodes` outputs a list of Kubernetes node names and status. If the cluster is composed of GCP GKE instances the output looks like:

```sh
$ kubectl get nodes
NAME                                       STATUS   ROLES    AGE     VERSION
gke-test-cluster-test-pool-00f50801-2v37   Ready    <none>   4h1m    v1.30.3-gke.1969002
gke-test-cluster-test-pool-11f58e14-ynyq   Ready    <none>   4h3m    v1.30.3-gke.1969002
gke-test-cluster-test-pool-369c992c-pdsy   Ready    <none>   3h58m   v1.30.3-gke.1969002
```

When for whatever reason (i.e. a node is in `NotReady` status) I want to `ssh` into a node I just want to copypaste the node name and `ssh` into it without having to run an additional `kubectl describe <NODE>` or some `jq` parsing to get the node IP.

So this `ssh` wrapper checks the host address and if it matches the GKE node name pattern it converts it into the actual instance IP before `ssh`ing into it.

## Installation

The most usual method is to simply copypaste the [`ssh()` function](gke-ssh-wrapper.sh) into your shell RC file: `~/.bashrc` for Bash, `~/.zshrc` for Zsh, etc. Then run `source <RC_file>` or simply open a new shell and your wrapper will be in place.

Run `which ssh` to check whether the installation was correct. Output should show the wrapper instead of `/usr/bin/ssh`.

## Usage

Once installed, just `ssh` normally but using the GKE node name instead. All passed in parameters (including the user in the form `user@host`) should just work ™️.

```
$ ssh gke-test-cluster-test-pool-00f50801-2v37
Warning: Permanently added '42.42.42.42' (ED25519) to the list of known hosts.

Welcome to Kubernetes v1.30.3-gke.1900!

You can find documentation for Kubernetes at:
  http://docs.kubernetes.io/

The source for this release can be found at:
  /home/kubernetes/kubernetes-src.tar.gz
Or you can download it at:
  https://storage.googleapis.com/kubernetes-release-gke/release/v1.30.3-gke.1900/kubernetes-src.tar.gz

It is based on the Kubernetes source at:
  https://github.com/kubernetes/kubernetes/tree/v1.30.3-gke.1900

For Kubernetes copyright and licensing information, see:
  /home/kubernetes/LICENSES

trutx@gke-test-cluster-test-pool-00f50801-2v37 ~ $
```

Tested in `bash` and `zsh`.