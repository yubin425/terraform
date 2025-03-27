#!/bin/bash

set -e  # 에러 발생 시 중단

APP_NAME="nginx"       # <- Argo CD 앱 이름
ARGOCD_NAMESPACE="argocd"

echo "==================================="
echo "[1] Argo CD Application 삭제"
echo "==================================="
kubectl delete application $APP_NAME -n $ARGOCD_NAMESPACE --ignore-not-found --cascade --grace-period 10 --timeout 60s

echo ""
echo "ArgoCD 앱이 정리될 시간을 조금 기다립니다 (30초)..."
sleep 30

echo "==================================="
echo "[2] Terraform Ingress 삭제"
echo "==================================="
kubectl patch ingress argocd-ingress -n argocd -p '{"metadata":{"finalizers":null}}' --type=merge
terraform destroy -target=kubernetes_ingress_v1.argocd_ingress -auto-approve

echo ""
echo "==================================="
echo "[3] 나머지 인프라 전체 삭제"
echo "==================================="
terraform destroy -auto-approve

echo ""
echo "모든 리소스를 성공적으로 삭제했습니다"
