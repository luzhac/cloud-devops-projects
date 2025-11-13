1.install in win 11
wsl --install -d Ubuntu

2.run in win 11  
wsl.exe -d Ubuntu


wsl

wsl --unregister Ubuntu

wsl --install -d Ubuntu

wsl -d Ubuntu

lsb_release -a

sudo apt update

sudo apt update && sudo apt upgrade -y

sudo apt install ansible -y



mkdir -p ~/.ssh/awskeys
cp /mnt/c/MyFiles/MyProjects/aws-infra-lab/infra/terraform/environments/dev/.secrets/k8s.pem ~/.ssh/awskeys/
chmod 400 ~/.ssh/awskeys/k8s.pem

chmod 777 ~/.ssh/awskeys/k8s.pem



 
cd /mnt/c/Myfiles/MyProjects/aws-infra-lab/infra/ansible

ansible-playbook -i inventories/dev/inventory.ini playbooks/install_script.yml



kubeadm token create --print-join-command










 



