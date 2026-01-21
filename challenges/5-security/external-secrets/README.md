# Fix Broken External Secret Sync

**Time:** 5 minutes
**Skills tested:** External Secrets Operator, Debugging, Secret Management

## Context

The team is migrating to External Secrets Operator (ESO) to manage secrets. A developer has configured an `ExternalSecret` to sync database credentials from the global secret store for the `payment-service`. However, the Kubernetes Secret is not being created.

## Task

Diagnose and fix the `ExternalSecret` in the `cnpe-eso-test` namespace so that the `payment-db-connection` Secret is successfully created.

### Phase 1: Diagnose the Error
Check the status of the `ExternalSecret` to find out why it is failing.

### Phase 2: Fix the Configuration
Update the `ExternalSecret` manifest to reference the correct property key from the secret store.

## Verification

The exercise validates:
1. The `payment-db-connection` Secret exists.
2. The Secret contains the `DB_PASSWORD` key with the correct value.

## Hints

```bash
# Check the status of the ExternalSecret
kubectl get externalsecret -n cnpe-eso-test
kubectl describe externalsecret payment-db-secret -n cnpe-eso-test
```

## Allowed Documentation

- [External Secrets Operator](https://external-secrets.io/latest/)
