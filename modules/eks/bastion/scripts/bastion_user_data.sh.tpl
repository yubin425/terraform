#!/bin/bash
set -e

# awscli
curl -s "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip -q awscliv2.zip
sudo ./aws/install
rm -rf aws awscliv2.zip
echo "awscli installed: $(aws --version)"

# kubectl
curl -LO "https://s3.us-west-2.amazonaws.com/amazon-eks/1.29.10/2024-12-12/bin/linux/amd64/kubectl"
chmod +x kubectl
sudo mv kubectl /usr/local/bin/
echo "kubectl installed: $(kubectl version)"

# eksctl
curl -sL "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
sudo mv /tmp/eksctl /usr/local/bin
echo "eksctl installed: $(eksctl version)"

# helm (optional, CLI용)
curl -s https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
echo "helm installed: $(helm version --short)"

# 확인용 로그
LOGFILE="/home/ec2-user/setup.log"
echo "CLI 설치 완료 at $(date)" >> $LOGFILE

# EKS kubeconfig 자동 연결
aws eks --region ${region} update-kubeconfig \
  --name ${cluster_name} \
  --kubeconfig /home/ec2-user/.kube/config

#루트에서 사용되는 것 방지
chown ec2-user:ec2-user /home/ec2-user/.kube/config
