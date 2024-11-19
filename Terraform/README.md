## Provisioning Terraform Resources

**Directory Structure**
```
 ── Terraform
    ├── ecs
    │   ├── cluster
    │   │   ├── backend-provider.tf
    │   │   ├── locals.tf
    │   │   ├── main.tf
    │   │   ├── outputs.tf
    │   │   ├── terraform.tfvars
    │   │   └── variable.tf
    │   ├── ecr
    │   │   ├── backend-provider.tf
    │   │   ├── locals.tf
    │   │   ├── main.tf
    │   │   ├── output.tf
    │   │   ├── terraform.tfvars
    │   │   └── variables.tf
    │   ├── loadbalancer
    │   │   ├── backend-provider.tf
    │   │   ├── data.tf
    │   │   ├── locals.tf
    │   │   ├── main.tf
    │   │   ├── output.tf
    │   │   ├── terraform.tfvars
    │   │   └── variables.tf
    │   └── service
    │       ├── backend-provider.tf
    │       ├── container_definition.json
    │       ├── data.tf
    │       ├── locals.tf
    │       ├── service.tf
    │       ├── terraform.tfvars
    │       └── variable.tf
    ├── lambda-http-api
    │   ├── backend_provider.tf
    │   ├── data.tf
    │   ├── http_api_gateway.tf
    │   ├── lambda_function.tf
    │   ├── locals.tf
    │   ├── outputs.tf
    │   ├── terraform.tfvars
    │   └── variables.tf
    ├── README.md
    └── vpc
        ├── backend-provider.tf
        ├── locals.tf
        ├── main.tf
        ├── output.tf
        ├── terraform.tfvars
        └── variables.tf
```

To provision any group of resources be it `vpc`,`ecs cluster`,`lambda function` following are basic set of commands that needs to followed.

- First we need to get inside the directory. Let take an example of **VPC**
  ```bash
      cd vpc
  ```
- Initialize Terraform
  ```bash
       terraform init
  ```
- Create Terraform Workspace. [Learn more about terraform workspaces.](https://developer.hashicorp.com/terraform/language/state/workspaces)

  ```bash
        terraform workspace new prod
  ```

  **_Make sure to keep the workspace name constant across all resources to avoid conflicts for interdependent resources._**

- Check the configuration in `terraform.tfvars` file. Make any changes as per requirements.Then review execution plan.
  ```bash
       terraform plan
  ```
- Apply Terraform Configuration
  ```bash
       terraform apply
  ```

## Deploying Flask App on ECS

### Create VPC

1. Naviate to VPC Folder
2. Make Changes to `backend-provider.tf` to specify appropriate backend for storing terraform state.
3. Create Workspace.
4. Run `terraform init`
5. Review configuration in `terraform.tfvars`, then execute plan and apply configuration.

### Create ECS Resources

Navigate to `ecs` folder inside `Terraform` folder. Create Resources in Following Order.

#### Create ECR repository and Push Docker Image:

- Navigate to `ecr` folder.
- Make Changes to `backend-provider.tf` and initialise terraform.
- Create Workspace with the same name as created in earlier stages.
- Make changes to `terraform.tfvars` and Check execution plan.
- Apply changes.

#### Pushing Image to ECR:

- Build Image :
  ```bash
      docker build -t <image-name> .
  ```
- Tag Image :
  ```bash
      docker tag flask-app:latest <AWS_ACCOUNT_ID>.dkr.ecr.<REGION>.amazonaws.com/<ecr_repository_name>:latest
  ```
- Login to ECR :
  ```bash
      aws ecr get-login-password --region <REGION> | docker login --username AWS --password-stdin <AWS_ACCOUNT_ID>.dkr.ecr.<REGION>.amazonaws.com
  ```
- Push Image :
  ```bash
    docker push <AWS_ACCOUNT_ID>.dkr.ecr.<REGION>.amazonaws.com/<ecr_repository_name>:latest
  ```

#### Creating Loadbalancer and ECS Cluster

- Follow similar steps to the above for creating Loadbalancer and ECS Cluster by navigating to `loadbalancer` and `cluster` folder respectvely.

- Make sure to change `backend-provider` configuration before initialising. Review tfvars configuration before exeucting plan.
- Create workspace before creating plan
- While creating loadbalancer ACM Certificate ARN is required while creating HTTPS Listener. [Refer here for creating ACM Certificate.](https://docs.aws.amazon.com/res/latest/ug/acm-certificate.html).

#### Creating ECS Service

- Follow above specified steps for initialising terraform.
- Create workspace same as in previos steps.
- Go to `container_definition.json`. Replace `<image_uri>` with ecr image uri that we pushed in the above steps.
- Review configuration in `terraform.trvars`then plan and apply.
- Check in ECS Console if tasks under service are running, troubleshoot if any issues arise.

### Access The Application:

Retrive the Loadbalancer DNS from terraform outputs and navigate to:

```url
    https://<ALB_DNS>/list-bucket-content
```

## Deploy using Lambda and HTTP API

### Create Resources

- Navigate to `lambda-http-api` folder inside `Terraform` directory
- Make Changes to `backend-provider.tf` and initialise terraform.
- Create workspace with desired name.
- Make changes to tfvars and check execution plan.
- Apply configuration

### Access API

Copy API Gateway URL from Outputs and navigate to:

```url
https://<API_GATEWAY_URL>/list-bucket-content
```

## Cleaning up Resources

To Delete the resources create

1. Navigate to Folder

```bash
cd <folder_path>
```

2. Select Workspace

```bash
terraform workspace select <workspace_name>
```

3. Destroy Resources

```bash
terraform destroy
```
