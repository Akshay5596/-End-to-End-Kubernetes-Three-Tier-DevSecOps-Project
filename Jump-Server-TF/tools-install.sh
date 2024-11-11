#!/bin/bash

# Update and install dependencies
sudo apt update -y

# Installing Java (OpenJDK 17)
echo "Installing Java..."
sudo apt install openjdk-17-jre openjdk-17-jdk -y
java --version

# Installing Docker
echo "Installing Docker..."
sudo apt install docker.io -y
sudo usermod -aG docker jenkins
sudo usermod -aG docker ubuntu
sudo systemctl restart docker
sudo chmod 777 /var/run/docker.sock

# Run Docker Container for SonarQube
echo "Running SonarQube container..."
docker run -d --name sonar -p 9000:9000 sonarqube:lts-community

# Installing AWS CLI
echo "Installing AWS CLI..."
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
sudo apt install unzip -y
unzip awscliv2.zip
sudo ./aws/install

# Installing kubectl
echo "Installing kubectl..."
sudo apt install curl -y
sudo curl -LO "https://dl.k8s.io/release/v1.28.4/bin/linux/amd64/kubectl"
sudo chmod +x kubectl
sudo mv kubectl /usr/local/bin/
kubectl version --client

# Installing eksctl
echo "Installing eksctl..."
curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
sudo mv /tmp/eksctl /usr/local/bin
eksctl version

# Installing Trivy
echo "Installing Trivy..."
sudo apt-get install wget apt-transport-https gnupg lsb-release -y
wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | sudo apt-key add -
echo deb https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -sc) main | sudo tee -a /etc/apt/sources.list.d/trivy.list
sudo apt update
sudo apt install trivy -y

# Installing Helm
echo "Installing Helm..."
sudo snap install helm --classic

# Add Helm repositories for ArgoCD, Prometheus, and Grafana
echo "Adding Helm repositories for ArgoCD, Prometheus, and Grafana..."
helm repo add argo https://argoproj.github.io/argo-helm
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add grafana https://grafana.github.io/helm-charts

# Update Helm repositories
echo "Updating Helm repositories..."
helm repo update

# Install Argo CD using Helm
echo "Installing Argo CD..."
helm install argo-cd argo/argo-cd --create-namespace --namespace argocd

# Install Prometheus using Helm
echo "Installing Prometheus..."
helm install prometheus prometheus-community/kube-prometheus-stack --create-namespace --namespace monitoring

# Install Grafana using Helm
echo "Installing Grafana..."
helm install grafana grafana/grafana --create-namespace --namespace monitoring

# Print the statuses of the installations
echo "Verifying the installations..."
kubectl get pods --namespace argocd
kubectl get pods --namespace monitoring

echo "All installations are complete."
