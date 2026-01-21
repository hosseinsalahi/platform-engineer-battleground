# Solution: RBAC Least Privilege

Create a Role and bind it to the ServiceAccount:

```bash
cat <<'YAML' | kubectl apply -f -
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: app-reader-configmaps
  namespace: cnpe-rbac-min
rules:
  - apiGroups: [""]
    resources: ["configmaps"]
    verbs: ["get", "list", "watch"]
---
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: app-reader-configmaps
  namespace: cnpe-rbac-min
subjects:
  - kind: ServiceAccount
    name: app-reader
    namespace: cnpe-rbac-min
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: Role
  name: app-reader-configmaps
YAML
```

Verify:

```bash
kubectl auth can-i get configmaps -n cnpe-rbac-min \
  --as=system:serviceaccount:cnpe-rbac-min:app-reader
kubectl auth can-i list secrets -n cnpe-rbac-min \
  --as=system:serviceaccount:cnpe-rbac-min:app-reader
```

