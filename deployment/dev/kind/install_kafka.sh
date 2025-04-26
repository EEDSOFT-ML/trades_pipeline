#!/bin/bash


# Delete the old namespace if it exists
kubectl delete namespace mlseries --ignore-not-found

# (Optional) Delete kafka namespace too if you used it
kubectl delete namespace kafka --ignore-not-found

# Wait for namespaces to fully terminate
echo "Waiting for namespaces to terminate..."
sleep 10

# Recreate the namespace fresh
kubectl create namespace mlseries

# Install Strimzi into mlseries namespace (corrects namespace automatically)
curl -L https://strimzi.io/install/latest | sed 's/namespace: .*/namespace: mlseries/' | kubectl apply -n mlseries -f -

# (Optional) Wait a few seconds to let operator come up
echo "Waiting for Strimzi operator to start..."
sleep 20

# Apply your Kafka custom resource (replace with your own file if needed)
kubectl apply -f manifests/kafka-e11b.yaml -n mlseries

echo "✅ All done! Check pods with: kubectl get pods -n mlseries"
