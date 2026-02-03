# Testing GitHub Secrets

This commit will trigger GitHub Actions to test if secrets are properly configured.

Expected workflow:
1. CI: Run tests (should pass)
2. CD: Build Docker images (should pass if secrets are set)
3. CD: Deploy to dev (will fail without kubeconfig - that's OK)

Check workflow run at: https://github.com/MartinS984/three-tier-nodejs-devops/actions
