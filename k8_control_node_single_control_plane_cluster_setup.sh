# Enter password as arg 1, otherwise will be assigned blank password
K8USERPASSWORD=$1

# Starts setup of Control Node
kubeadm init 2>&1 | kubeadm.log

# Create User to administrate with kubectl
useradd k8user
usermod -aG wheel k8user
echo $K8USERPASSWORD | passwd k8user --stdin
su - k8user
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# Install Weave Net CNI
kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')"
