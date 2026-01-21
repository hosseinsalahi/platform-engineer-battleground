# RBAC Least Privilege

**Domain:** Security and Policy Enforcement (15%)
**Competency:** Applying RBAC and Security Controls Across Platform Resources
**Time:** 7 minutes

## Context

An application uses a ServiceAccount to read ConfigMaps in its namespace. The ServiceAccount currently has **no permissions**, and someone might be tempted to bind it to `cluster-admin`.

## Task

Grant the ServiceAccount `app-reader` the **minimal** permissions needed to read ConfigMaps in `cnpe-rbac-min`, without granting access to Secrets.

## Requirements

- ServiceAccount: `app-reader` (already exists)
- Namespace: `cnpe-rbac-min`
- Must be able to `get` ConfigMaps
- Must **not** be able to `list` Secrets

## Hints

```bash
kubectl auth can-i get configmaps -n cnpe-rbac-min \
  --as=system:serviceaccount:cnpe-rbac-min:app-reader

kubectl auth can-i list secrets -n cnpe-rbac-min \
  --as=system:serviceaccount:cnpe-rbac-min:app-reader
```

## Allowed Documentation

- https://kubernetes.io/docs/reference/access-authn-authz/rbac/
- https://kubernetes.io/docs/reference/kubectl/generated/kubectl_auth/kubectl_auth_can-i/

