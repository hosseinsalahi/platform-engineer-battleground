# Solution

The `ExternalSecret` was failing because it referenced a non-existent property `pass_word` in the `remoteRef`. The correct property in the `Fake` provider data is `password`.

## Fixed ExternalSecret

```yaml
apiVersion: external-secrets.io/v1beta1
kind: ExternalSecret
metadata:
  name: payment-db-secret
  namespace: cnpe-eso-test
spec:
  refreshInterval: 1m
  secretStoreRef:
    name: global-fake-store
    kind: ClusterSecretStore
  target:
    name: payment-db-connection
    creationPolicy: Owner
  data:
  - secretKey: DB_HOST
    remoteRef:
      key: "/prod/payment-service/db"
      property: "host"
  - secretKey: DB_PASSWORD
    remoteRef:
      key: "/prod/payment-service/db"
      property: "password" # Fixed typo
```

## Diagnosis Steps

1.  Run `kubectl describe externalsecret payment-db-secret -n cnpe-eso-test`.
2.  Observe the status condition `SecretSynced` is `False`.
3.  Read the error message: `key "pass_word" not found`.
4.  Edit the object: `kubectl edit externalsecret payment-db-secret -n cnpe-eso-test`.
5.  Change `pass_word` to `password`.
