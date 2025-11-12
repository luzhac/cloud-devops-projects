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
 
cd /mnt/c/Myfiles/MyProjects/aws-infra-lab/infra/ansible

ansible-playbook -i inventories/dev/inventory.ini playbooks/install_script.yml






 



