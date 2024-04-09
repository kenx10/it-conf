# on admin machine

kubectl get po -n kube-system
kubectl apply -f https://github.com/coreos/flannel/raw/master/Documentation/kube-flannel.yml

# test
kubectl run nginx --image=nginx --port=80
kubectl expose pod nginx --port=80 --type=NodePort

kubectl get svc
kubectl get pods --all-namespaces --output wide


helm repo add kubernetes-dashboard https://kubernetes.github.io/dashboard/
helm upgrade --install kubernetes-dashboard kubernetes-dashboard/kubernetes-dashboard --create-namespace --namespace kubernetes-dashboard

kubectl apply -f dashboard-admin.yaml
kubectl -n kubernetes-dashboard create token admin-user