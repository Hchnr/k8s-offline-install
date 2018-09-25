sudo kubeadm init --pod-network-cidr=172.16.0.0/16   --apiserver-advertise-address=192.168.22.11  --kubernetes-version=v1.11.1  | tee k8s.init.log

if [ $? == 0 ] ;then
  mkdir -p $HOME/.kube
  echo y | sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config
  kubectl apply -f rbac-kdd.yaml
  kubectl apply -f calico.yaml
  #kubectl apply -f https://docs.projectcalico.org/v3.1/getting-started/kubernetes/installation/hosted/rbac-kdd.yaml | tee k8s.rbac-kdd.log
  #kubectl apply -f https://docs.projectcalico.org/v3.1/getting-started/kubernetes/installation/hosted/kubernetes-datastore/calico-networking/1.7/calico.yaml  | tee k8s.calico.log
fi
