🧰 Technologies Used
Component	Purpose
Jenkins	CI/CD automation
Terraform	Infrastructure as Code (IaC)
AWS EC2	Host server for deployment
Docker	Containerize Node.js application
Node.js	Backend web application
GitHub	Source code repository

🪄 Pipeline Stages (Jenkinsfile)
Checkout – Pulls source code from GitHub.
Build Docker Image – Builds the Node.js app image locally.
Terraform Init & Apply – Provisions AWS infrastructure using Terraform.
Deploy App – Terraform user_data installs Docker and runs the container on EC2.
🧑‍💻 How to Run Locally

1️⃣ Prerequisites
AWS Account with IAM Access Key & Secret.
Jenkins installed with Terraform and Docker plugins.
Git installed.
SSH key pair generated (for Terraform EC2 access).

2️⃣ Configure Jenkins Credentials
ID	Type	Description
aws-access-key	Secret Text	AWS Access Key
aws-secret-key	Secret Text	AWS Secret Key
gitrepoaccess	Username/Password or Token	Access for GitHub repo
ec2-ssh-key	SSH Key	Private key to connect to EC2 instance

3️⃣ Run Jenkins Pipeline
Create a new Pipeline project in Jenkins.
Point it to this GitHub repository.
Run the build — Jenkins will:
Clone the repo
Build the Docker image
Apply Terraform configuration
Deploy and start the container on EC2

4️⃣ Verify Deployment
Get EC2 public IP using:
terraform output ec2_public_ip
