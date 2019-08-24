#/bin/bash

if [ $1 == "start" ]; then
  command="while true; do wget -q -O- http://frontend.$2.svc.cluster.local; done"
  kubectl run load-generator --image=busybox -- /bin/sh -c "while true; do wget -q -O- http://frontend.$2.svc.cluster.local; done"
fi

if [ $1 == "stop" ]; then
  kubectl delete deploy load-generator
fi

sleep 10

echo "The current replica status\n"
kubectl get hpa -n $2


