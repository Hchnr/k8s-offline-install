k8s集群安装记录

https://www.kubernetes.org.cn/4387.html
https://tower.im/projects/14c221e3b5374d6dbf1ebefdbe9522e9/docs/34c7c12da8a34a03b906287ecb933dcd/

1. 环境

Master x1: Ubuntu 16.04 
Slave  x1: Ubuntu 16.04
Kubernetes: v1.11.1
Docker: 18.03.1-ce


2. 使用 Vagrant + Virtual Box 创建两个Ubuntu16.04的虚拟机
(Windows下创建虚拟机卡死可以重新安装 Vagrant + Virtual Box)

IP： Master: 192.168.22.11  Slave: 192.168.22.12
可以使用下面的VagrantFile：

Vagrant.configure("2") do |config|
  config.vm.box = "k8s-1"
  config.vm.network "private_network", ip: "192.168.22.11"
  config.vm.synced_folder "../workspace", "/home/vagrant/workspace"
  config.vm.provider "virtualbox" do |vb|
    vb.gui = false
    vb.memory = "2048"
    vb.cpus = "2"
    vb.customize [ "modifyvm", :id, "--uartmode1", "disconnected" ]
  end
end

vagrant up # 启动虚拟机
vagrant ssh # ssh到虚拟机
vagrant halt  # 关闭虚拟机，通常情况下，无需关闭

3. 禁用SWAP、修改主机名（关闭防火墙、关闭SELINUX、配置主机名、IP地址等开发环境下不需要）
swapoff -a
sudo hostname k8s-master
sudo hostname k8s-node0
添加对应的地址解析到 /etc/hosts

4. 安装 Docker 18.03.1-ce (已安装)

5. 安装 Kubeadm 等程序
cd k8s.deb.v1.11.1  && ./install.sh

6. On Master 导入镜像
cd k8s.master.v1.11.1 && ./loadall.sh

7. On Master 初始化集群, 通过LOG文件查看客户端加入的命令
cd kubeadm_init  && install.sh  #注意修改脚本中初始化的网络地址
kubectl get nodes

8. On Node 导入镜像
cd k8s.node.v1.11.1  && ./loadall.sh

9. On Node 加入集群, 具体命令查看日志 k8s.init.log
scp vagrant@k8s-master:/home/vagrant/.kube/config ~/.kube/
kubeadm join ...
kubectl get nodes

10. 安装Dashboard
cd kubernetes-dashboard && ./install.sh

11.   安装Nginx-ingress
On Master:
 cd nginx-ingress && ./install_on_node.sh
On Node:
 cd nginx-ingress && ./install_on_master.sh