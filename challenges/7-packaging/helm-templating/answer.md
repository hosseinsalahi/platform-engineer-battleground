# Solution: Fix Broken Helm Chart

## 1. Identify the Errors
Run `helm template . --debug`:
```bash
helm template . --debug
```
You will see errors about `nil pointer evaluating interface {}`.

## 2. Fix `templates/deployment.yaml`

**Error 1:** `replicas: {{ .Values.replicas }}`
In `values.yaml`, the key is `replicaCount`.
Change to: `replicas: {{ .Values.replicaCount }}`

**Error 2:** `imagePullPolicy: {{ .Value.image.pullPolicy }}`
Typo in object name `Value`.
Change to: `imagePullPolicy: {{ .Values.image.pullPolicy }}`

## 3. Install
```bash
helm install web-app ./chart -n cnpe-packaging
```
