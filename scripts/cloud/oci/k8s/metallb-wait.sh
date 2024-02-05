#!/bin/bash -p

kubectl wait --for jsonpath='{.status.phase}=Active' --timeout=10s namespace/metallb-system
for i in $(seq 1 10);
do
    kubectl get svc -n metallb-system webhook-service >/dev/null
    test $? -eq 0 && break
    sleep 1
done
kubectl wait --namespace metallb-system --for=condition=ready pod \
    --selector=component=controller --timeout=90s

for interval in $(seq 1 120);
do
    kubectl get nodes | grep NotReady
    test $? -ne 0 && break
    sleep 1
done

for interval in $(seq 1 100);
do
    output=$(kubectl apply -f /etc/kubernetes/metallb-config.yaml)
    if [ $? -eq 0 ]; then
        echo "$output" | grep unchanged
        test $? -eq 0 && break
    fi
    sleep 1
done
