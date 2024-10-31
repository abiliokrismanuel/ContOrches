# init cluster kubeadm with calico
sudo kubeadm init --control-plane-endpoint=<ip-master>:6443 \
  --pod-network-cidr=192.168.0.0/16 \
  --upload-certs

# init cluster kubeadm with flannel
sudo kubeadm init --control-plane-endpoint=<ip-master>:6443 \
  --pod-network-cidr=10.244.0.0/16 \
  --upload-certs

# re print cert and re print join control plane
kubeadm init phase upload-certs --upload-certs
kubeadm token create --print-join-command --certificate-key <certificate-key>

# re print worker
kubeadm token create --print-join-command

# reg user
  mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config
# nginx ingress NGINX+
https://github.com/nginxinc/kubernetes-ingress/tree/main

# taint
kubectl taint nodes --all node-role.kubernetes.io/control-plane

# untaint
kubectl taint nodes --all node-role.kubernetes.io/control-plane-

# flannel
kubectl apply -f https://github.com/flannel-io/flannel/releases/latest/download/kube-flannel.yml

firewall-cmd --permanent --add-port=8285/udp # Flannel
firewall-cmd --permanent --add-port=8472/udp # Flannel

kubectl apply -f https://github.com/canonical/microk8s-core-addons/blob/main/addons/ingress/ingress.yaml
# calico
kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.28.2/manifests/tigera-operator.yaml

kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.28.2/manifests/custom-resources.yaml


# ingress-nginx-baremetal-nodeport
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.12.0-beta.0/deploy/static/provider/baremetal/deploy.yaml

# delete ns
kubectl delete namespace <namespace>

# busybox
kubectl run -i --tty --rm debug --image=busybox --restart=Never -- sh

# del
rm -rf  /etc/cni/net.d/

rm -rf $HOME/.kube/config