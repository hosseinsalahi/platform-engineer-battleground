# Solution

```yaml
apiVersion: autoscaling/v1
kind: HorizontalPodAutoscaler
metadata:
  name: php-apache-hpa
  namespace: cnpe-scaling
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: php-apache
  minReplicas: 2
  maxReplicas: 10
  targetCPUUtilizationPercentage: 50
```

Apply with:
```bash
kubectl apply -f hpa.yaml
```

Alternatively imperative:
```bash
kubectl autoscale deployment php-apache --cpu-percent=50 --min=2 --max=10 -n cnpe-scaling
```
