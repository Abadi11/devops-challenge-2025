# ⚙️ CI/CD Pipeline – Terraform Deployment via GitHub Actions

This repository includes a CI/CD pipeline powered by **GitHub Actions** to automate the validation, planning, and optional deployment of infrastructure defined in Terraform.

## 📄 `deploy-aws.yml`

It runs manually on **workflow_dispatch** event, to add the optionality of deployments in a real deployment scenario. 

🔤 **Inputs** 
- **environment:** Two environments have been added to the repo with their own secrets, dev & prod. If one of them selected it will simulate a deployment in that env.
- **destroy:** It is a boolean input if an infrastructure no longer needed.

It includes the following stages:

### 1. **Terraform Initialization**
- Sets up Terraform CLI using the official `setup-terraform` action.
- Caches previously downloaded providers/modules using `actions/cache` to speed up future runs.

### 2. **Validation & Planning**
- Runs `terraform init` and `terraform validate` to ensure syntax and structure are correct.
- Executes `terraform plan` to preview infrastructure changes and save the plan to a file.

### 3. **Simulated Deployment**
- `terraform apply`, the pipeline will run apply manually if needed for future step.
- `terraform destroy`, the pipeline will run destroy manually if needed for future step.

## 📄 `test.yml`

This workflow performs a test using terraform test packages:

- Initializes Terraform.
- Test the infrastructure.

## 📄 `tflint.yml`

This GitHub Actions workflow runs on every push and pull request to validate Terraform code against best practices using `terraform-linters/setup-tflint` action.

It includes the following stages:

### 1. **tflint Initialization**
- Sets up tfling CLI using `terraform-linters/setup-tflint` action.
- Caches previously downloaded tflint plugins using `actions/cache` to speed up future runs.

### 2. **Terraform Validation**
- Runs `tflint --init` to easily install the plugins.
- Executes `tflint -f compact` to use the compact output format in readable way and one-line issue print out.