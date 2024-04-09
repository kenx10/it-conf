# ./1-base.sh
# install proxy for master nodes


# for first master node use proxy IP
kubeadm config images pull
kubeadm init --control-plane-endpoint "192.168.1.46:6443" --upload-certs --pod-network-cidr=10.244.0.0/16

# results like
kubeadm join 192.168.1.46:6443 --token 18on8w.kg0e3d6a2mldj2g2 \
	--discovery-token-ca-cert-hash sha256:cca7758d814efd4a5198bece80e1d1f726b5912019ee91ff0f33e792b23c1f90 \
	--control-plane --certificate-key 7248caf8eaff99e1f8138839d6c5b0ea96fcf11839ca5c9543d3c5aa9af898a8

kubeadm join 192.168.1.46:6443 --token 18on8w.kg0e3d6a2mldj2g2 \
	--discovery-token-ca-cert-hash sha256:cca7758d814efd4a5198bece80e1d1f726b5912019ee91ff0f33e792b23c1f90

# if forgot
kubeadm token create --print-join-command

mkdir -p $HOME/.kube
yes | sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
yes | sudo chown $(id -u):$(id -g) $HOME/.kube/config

# need to local kubectl
cat $HOME/.kube/config


# for others masters get from line 10
kubeadm config images pull
kubeadm join 192.168.1.46:6443 --token 4uaaju.66eknjs4mizren1y \
	--discovery-token-ca-cert-hash sha256:52c9499cca8eaa6de1b781d9846d508e4d19c0d7d62fdde793cd9e2800a32987 \
	--control-plane --certificate-key 4233ecd8736f3e847265c78d42ddd4b37beacd7d9a0cda95f642f02c03fd068e

# for workers get from line 14
kubeadm join 192.168.1.46:6443 --token 4uaaju.66eknjs4mizren1y \
	--discovery-token-ca-cert-hash sha256:52c9499cca8eaa6de1b781d9846d508e4d19c0d7d62fdde793cd9e2800a32987

# if need start
kubeadm reset --cri-socket=unix:///var/run/crio/crio.sock
kubeadm reset --force
sudo rm -R /etc/cni/net.d

# see config map
kubectl get cm kubeadm-config -n kube-system -o yaml
