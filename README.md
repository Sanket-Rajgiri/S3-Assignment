# S3 Listing Assignment

Repository Contains two implementations for Listing S3 Bucket Contents

1. **Containerised App:** A Containerized Flask App which is deployed on ECS and exposed using ALB.

   ![Containerised App](/Screenshots/docs/ECS.png)

2. **Lambda with HTTP API Gateway:** A Lambda Function which is exposed via HTTP API.

   ![Lambda-HTTP-API](/Screenshots/docs/Lambda-HTTP-API.png)

**Directory Structure:**

```
├── Flask App # Flask App Code
├── Lambda Function # Lambda Function Code
└── Terraform # Terraform Configuration
    ├── ecs
    │   ├── cluster
    │   ├── ecr
    │   ├── loadbalancer
    │   └── service
    ├── lambda-http-api
    └── vpc

```

## Prerequisites for Running Locally

- **Python 3.x** (ensure it's installed by running `python --version`)
- **pip** (Python Package Manager for installing dependencies)
- **Git** (to clone the repository)

## Installation

1. **Clone the repository:**  
   Clone the repository to your local machine:

   ```bash
   git https://github.com/Sanket-Rajgiri/S3-Assignment.git
   cd S3-Assignment
   ```

2. **Install dependencies:**

   ```bash
   pip install -r requirements.txt
   ```

3. **Configure Credentials and Environment Variables:**

- Configure AWS Credentials via environment Variables (AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY, AWS_REGION)
  or
- Use `aws configure` (required aws-cli)
- Set `BUCKET_NAME` in environment variables.
  ```bash
      export BUCKET_NAME=<bucket-name>
  ```

4. **Running the Application**
   Run the application locally using:

```bash
python app.py
```

## Running with Docker

You can Find all the Required files in `FLASK App` directory.

1. **Build the Docker image**
   Build the Docker image using the provided Dockerfile:

```bash
docker build -t your-image-name .
```

2. **Set up environment variables**
   Create a .env file to pass to docker container. Use the below format:

```bash
AWS_ACCESS_KEY_ID=
AWS_SECRET_ACCESS_KEY=
AWS_REGION=
BUCKET_NAME=

```

3. **Run the Docker container**
   Run the application in a container:

```bash
docker run --env-file .env -p 8000:8000 your-image-name
```

## Terraform Infrastructure Provisioning

You can find detailed document inside `Terraform` to provision resources.

## Demo Video Link 

Due to filesize restrictions, upload compressed video to repository. If any issues in viewing content, please [refer here](https://drive.google.com/file/d/1r_goeLEOSWORcHfPmuAO_SQc4j5YBXo1/view?usp=drive_link)
