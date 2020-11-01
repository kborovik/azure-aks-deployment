# Azure Kubernetes Services (AKS) - Infrastructure as Code

This work aims to explore ways to automate Continuous Delivery and Continuous Deployment of applications in the context of Microsoft Azure Kubernetes Services (AKS).

---

## CI/CD Pipeline

![CI/CD Pipeline](cicd.png)

---

## Git Branches Definition

Each Git branch represents a Azure deployment environment (DEV, STG, PRD).

---

## Workflow

[**PR**] => [**development**] => [**PR**] => [**staging**] => [**PR**] => [**production**]

- Clone **development** branch into a local branch named after an issue (**issue**)
- Create PR into **development** branch (DEV) from **issue** branch
- Attach issue to the PR
- Push changes into **issue** branch
- Confirm successful GitHub Actions run
- Merge PR into **development** branch
- Create PR from **development** into **staging** branch
- Merge PR
- Create PR from **staging** into **production** branch
- Merge PR

---

## Azure Deployment Environments

| Deployment Target | Uptime         | Purpose                        |
| ----------------- | -------------- | ------------------------------ |
| **development**   | 50% or less    | add & test new features        |
| **staging**       | 90% or more    | test integration & performance |
| **production**    | 99.99% or more | run production                 |
