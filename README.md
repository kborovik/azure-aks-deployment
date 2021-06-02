# Azure Kubernetes Services (AKS) - Infrastructure as Code

This work aims to explore ways to automate Continuous Delivery and Continuous Deployment of applications in the context of Microsoft Azure Kubernetes Services (AKS).

---

# The Problems I Work to Address

- What is the difference between **development**, **staging**, and **production** infrastructure configuration at any given time?
- Can the human error be eliminated during the change promotion between **development**, **staging** and **production** environments?
- Can the changes to the infrastructure and application code be **safely** end-to-end tested?
- Can the 1% failure rate of **production** services be reproduced in a **staging** environment?

![Code Testing](code-test.jpeg)

---

# Solution

## CI/CD Pipeline

![CI/CD Pipeline](cicd.png)

---

## Git Branches

Each Git branch represents a Azure deployment environment:
- development (DEV)
- staging (STG)
- production (PRD)

---

## Azure Deployment Environments

| Deployment Target | Uptime         | Purpose                        |
| ----------------- | -------------- | ------------------------------ |
| **development**   | 50% or less    | add & test new features        |
| **staging**       | 90% or more    | test integration & performance |
| **production**    | 99.99% or more | run production                 |

---

## Merge Strategy

By default, Github uses Merge Commit as a merge strategy. To accurately trace the Azure infrastructure deployment state, the merge strategy MUST be set to Rebase (Fast Forward).

Merge Commit workflow works excellent for developers where many changes worked simultaneously and commit velocity is more important than system state tracking. However, from the Azure infrastructure point of view, the deployment state is more critical than commit velocity.

Fast Forward merge strategy allows accurately track deployment state at the expense of commit velocity.

---

## Workflow

(**code**) ==> (**git_push**) => [**development**] => (**rebase-ff**) => [**staging**] => (**rebase-ff**) => [**production**]

- Check out the repository
- Code the change
- Push changes into **remote/development**
- Confirm successful deployment of **development** environment
- Promote the change to **staging** environment by rebasing (Fast-Forward) local **staging** on top of local **development**
- Push changes into **remote/staging**
- Confirm successful deployment of **staging** environment
- Promote the change to **production** environment by rebasing (Fast-Forward) local **production** on top of local **staging**
- Push changes into **remote/production** branch
- Confirm successful deployment of **production** environment
