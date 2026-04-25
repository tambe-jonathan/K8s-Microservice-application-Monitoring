## Application Deployment

The Sock Shop application is not stored directly in this repository.

Instead, it is dynamically fetched from its upstream source during deployment.

This ensures:
- Up-to-date manifests
- Reduced repository size
- Clear separation between application and platform

Deployment script:
bash operations/deploy-app.sh
