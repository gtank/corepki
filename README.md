A collective repo for TLS-related support scripts. Mostly intended for personal
reference.

The Makefile supports generating certs for etcd clusters and Kubernetes
deployments. For example, `make ca k8s tarballs` will generate the TLS assets
necessary to use the install scripts in `k8s/`. To create certs that will work
outside of testing, you will have to edit the config JSON files to include
valid hostnames or IPs.
