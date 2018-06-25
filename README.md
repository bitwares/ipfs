# ipfs setup

# 1. Install an nginx reverse proxy + cache for an ipfs-cluster peer gateway on Linux.

$ wget https://raw.githubusercontent.com/hautph/ipfs/master/ipfs-cluster-nginx.sh

$ bash ipfs-cluster-nginx.sh

$ sudo systemctl status nginx

$ sudo tail -f /var/log/nginx/access.log

# 2. Install an ipfs-cluster peer on Linux.

First node (node_0) setup

$ export CLUSTER_SECRET=$(od  -vN 32 -An -tx1 /dev/urandom | tr -d ' \n')

$ echo $CLUSTER_SECRET

<secret> <-- other nodes must also use this secret
             
Jump down to Run the installer.

Other nodes (node_n>0) setup

On node_0 after running the installer,

$ journalctl -u ipfs-cluster -n10

In the above log output, look under the line INFO cluster: IPFS Cluster v0.3.0 listening on: cluster.go:91 and make a note of the full non-loopback ip4 cluster multiaddress (cluster.listen_multiaddress). This will reference your instance's private IP address and will be used to bootstrap other nodes.

Back to other nodes (node_n>0),

$ export CLUSTER_SECRET=<node_0 secret>

$ export CLUSTER_BOOTSTRAP=<node_0 cluster.listen_multiaddress w/ instance private IP>

Run the installer

$ wget https://raw.githubusercontent.com/hautph/ipfs/master/ipfs-cluster-linux.sh

$bash ipfs-cluster-linux.sh

$ sudo systemctl status ipfs

$ sudo systemctl status ipfs-cluster

$ journalctl -u ipfs-cluster --follow

# 3. Install ipfs on Linux.

$ wget https://raw.githubusercontent.com/hautph/ipfs/master/ipfs.sh

$ bash ipfs.sh

$ sudo systemctl status ipfs

$ journalctl -u ipfs --follow





