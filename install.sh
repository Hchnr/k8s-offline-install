
installOnMaster() {
    sudo swapoff -a
    sudo hostname k8s-master
    cd k8s.v1.11.1/k8s.deb.v1.11.1  && ./install.sh && cd ../..
    cd k8s.v1.11.1/k8s.master.v1.11.1 && ./loadall.sh && cd ../..
    echo y | sudo kubeadm reset
    cd kubeadm_init  && ./install.sh && cd ..  #注意修改脚本中初始化的网络地址
    cd kubernetes-dashboard && ./install.sh && cd ..

}


if [ $# -lt 1 ]
then
    echo "Usage: auto-install master-ip node0-ip node1-ip ..."
fi

# install on master
echo "master ip:$1"
ip=$1
shift
installOnMaster $ip

node_index=0
while test $# != 0
do
    # install for node
    node_ip=$1
    shift
    node_name="k8s-node$node_index"
    echo " node name: $node_name, node ip: $node_ip"

    ssh vagrant@$node_ip << remotesh
    sudo swapoff -a
    sudo hostname $node_name
    cd workspace/k8s-offline
    cd k8s.v1.11.1/k8s.deb.v1.11.1  && ./install.sh && cd ../..
    cd k8s.v1.11.1/cd k8s.node.v1.11.1  && ./loadall.sh && cd ../..
    scp vagrant@k8s-master:/home/vagrant/.kube/config ~/.kube/
    echo y | sudo kubeadm reset
    sudo `cat kubeadm_init/k8s.init.log | grep "kubeadm join"`
    exit
remotesh

    node_index=`expr $node_index + 1`
done



