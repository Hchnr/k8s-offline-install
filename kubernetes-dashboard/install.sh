kubectl apply -f kubernetes-dashboard.yaml
kubectl apply -f kubernetes-dashboard_grant.yaml
kubectl proxy --address='0.0.0.0' --port=8001 --accept-hosts='^*$' &
echo "please visit http://MASTERIP:8001/api/v1/namespaces/kube-system/services/https:kubernetes-dashboard:/proxy/"
