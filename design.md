# Design Documentation – DevOps Challenge 2025

## ☁️ Cloud Platform: AWS
AWS was selected for its extensive documentation, reliable infrastructure, and flexibility. The EC2 service is ideal for serving a simple web page in this context.

## 🏗️ Infrastructure Components
- **EC2 Instance:** Amazon Linux 2, lightweight, cost-effective, and compatible with Apache.
- **Security Group:** Allows HTTP traffic (port 80) from anywhere.
- **User Data Script:** Automatically installs Apache and deploys a static `index.html`.

## ⚙️ CI/CD Pipeline: GitHub Actions

- **Why GitHub Actions?** Seamless with GitHub, YAML-based, widely used.
- The workflow is triggered on workflow_dispatch event which needs a human intervention. 
- The workflow simulates a deployment in two environments dev, and prod using:
  - `terraform init`
  - `terraform plan`
  - `terraform apply`
- Final step simulates deployment status feedback by adding run badges in the README.md for the deployment and test. It shows the status of the runs.