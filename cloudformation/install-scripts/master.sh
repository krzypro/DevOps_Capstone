#!/bin/bash

sudo apt update
sudo apt -y upgrade
sudo apt update
sudo apt -y install curl apt-transport-https
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt update
sudo apt -y install vim git curl wget kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab
sudo swapoff -a

sudo modprobe overlay
sudo modprobe br_netfilter
sudo tee /etc/sysctl.d/kubernetes.conf<<EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOF
sudo sysctl --system

sudo apt update

sudo apt install -y curl gnupg2 software-properties-common apt-transport-https ca-certificates
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt update
sudo apt install -y containerd.io docker-ce docker-ce-cli

sudo mkdir -p /etc/systemd/system/docker.service.d
printf "[Service]\nExecStartPost=/sbin/iptables -P FORWARD ACCEPT" |  sudo tee /etc/systemd/system/docker.service.d/10-iptables.conf

# Create daemon json config file
sudo tee /etc/docker/daemon.json <<EOF
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2"
}
EOF

# Start and enable Services
sudo systemctl daemon-reload
sudo systemctl restart docker
sudo systemctl enable docker

sudo hostnamectl set-hostname $(curl http://169.254.169.254/latest/meta-data/hostname)
sudo mkdir /etc/systemd/system/kubelet.service.d

sudo tee /etc/systemd/system/kubelet.service.d/20-aws.conf <<EOF
[Service]
Environment="KUBELET_EXTRA_ARGS=--node-ip=$(curl http://169.254.169.254/latest/meta-data/local-ipv4)"
EOF

sudo kubeadm init --token-ttl 0 --ignore-preflight-errors=NumCPU --ignore-preflight-errors=Mem | tail -3 > node-join

# configure kubernentes
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# enable AWS CNI
kubectl apply -f https://raw.githubusercontent.com/aws/amazon-vpc-cni-k8s/release-1.10/config/master/aws-k8s-cni.yaml

sudo apt -y install mc
sudo apt -y install lynx