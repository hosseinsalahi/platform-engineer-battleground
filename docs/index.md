# Platform Engineer Battleground

Hands-on, repo-first scenarios to practice platform engineering skills: Kubernetes, IaC, CI/CD, observability, security, and developer experience.

## What This Is
- A set of practical “battles” (scenarios) with clear goals and acceptance criteria
- A place to experiment safely and document learnings
- A TechDocs home page (for Backstage) when you wire it up

## Who It’s For
- Platform/DevOps/SRE engineers leveling up through deliberate practice
- App engineers who want to understand platform primitives and workflows

## Quick Start
Prereqs (adjust to your repo):
- Docker
- `kubectl`
- A local cluster (`kind` or `minikube`)
- Optional: `helm`, `terraform`, `jq`

Run (adjust):
- `make help`
- `make setup`
- `make test`

## How To Use This Repo
1. Pick a scenario from **Scenarios**
2. Read the goal + constraints
3. Implement the change
4. Validate using the provided checks
5. Capture learnings / notes

## Scenarios
- **Getting Started**: bootstrap + sanity checks
- **Kubernetes**: workloads, networking, RBAC, policies
- **CI/CD**: pipelines, artifacts, environments
- **Observability**: metrics, logs, traces, SLOs
- **Security**: supply chain, secrets, hardening
- **DX**: templates, golden paths, docs, automation

> Add links once the folders exist, e.g. `- [Kubernetes](kubernetes/README.md)`

## Repo Structure
- `docs/` – documentation (this site)
- `scenarios/` – hands-on challenges
- `scripts/` – helper scripts
- `infra/` – IaC, cluster bootstrap, etc.

## Contributing
- Keep scenarios small and measurable (clear “done” checks)
- Prefer automation + reproducibility over manual steps
- Add/update docs when behavior changes

## Notes
This is a learning environment—treat outputs as untrusted and avoid using real secrets.
