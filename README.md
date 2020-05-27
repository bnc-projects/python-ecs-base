# Terraform Python Base

## Build & Test

TO install requirements and run unit tests:

```bash
pip install -r requirements.txt
python -m unittest discover test

```

### Build and run locally on Docker
1. Build the docker container
```bash
docker build . -t ecs-base
```
2. Run the docker container 
```bash
docker run -t ecs-base
```

## Deployment

This project uses Terraform and the AWS CLI to deploy the service to the BNC ECS Cluster. To have the CI/CD pipeline deploy a service which has be 
deployed using a fork of this project you can follow the instructions below.

### Terraform ECS Workspaces

By default Terraform will not create the required workspaces. Before setting up the deployment in the CI environment, ensure you have created all of 
the appropriate workspaces.

The default workspaces for BNC are:
* development
* production

To create the workspaces run the following commands:
```
cd deployment/terraform/ecs-service
terraform workspace new production
terraform workspace new development
```

### Setting up Travis-CI deployment

1. Fill in the following environment variables.
```
AWS_DEFAULT_REGION=
STATE_S3_BUCKET=
STATE_DYNAMODB_TABLE=
KEY=<The project key for the ECR repository>, e.g bnc/<team>/ecr/<service-name>
SERVICE_KEY=<The project key for ECS service>, e.g ecs/<service-name>
SPLUNK_URL=
```

2. Encrypt the following global environment variables using the Travis-CI CLI.
```
DEPLOYMENT_ACCESS_KEY_ID=
DEPLOYMENT_SECRET_ACCESS_KEY=
KMS_KEY_ID=
ROLE_ARN=
OPERATIONS_ROLE_ARN=
```

2. Encrypt the following environment variables for the development deployment:
```
TF_WORKSPACE=
SPLUNK_TOKEN=
```

### Deployment to development ECS cluster

#### Terraform ECR Project

1. cd deployment/terraform/ecr

2. Copy `backend.tfvars.example` to `backend.tfvars`.

3. Fill out the `backend.tfvars`

4. Run `terraform init "-backend-config=backend.tfvars"`.

5. Copy `master.tfvars.example` to `master.tfvars`.

6. Fill in the `master.tfvars` with the correct values.

7. Now the project is fully setup and you will have the ability to run [terraform commands](https://www.terraform.io/docs/commands/index.html).
```
terraform plan "-var-file=master.tfvars"
```

#### Terraform ECS Project

1. cd deployment/terraform/ecs-service

2. Copy `backend.tfvars.example` to `backend.tfvars`.

3. Fill out the `backend.tfvars`

4. Run `terraform init "-backend-config=backend.tfvars"`.

5. Copy `master.tfvars.example` to `master.tfvars`.

6. Fill in the `master.tfvars` with the correct values.

7. Select the development work space `terraform workspace select development`

8. Now the project is fully setup and you will have the ability to run [terraform commands](https://www.terraform.io/docs/commands/index.html).
```
terraform plan "-var-file=master.tfvars"
```
