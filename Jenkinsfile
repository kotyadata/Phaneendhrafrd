pipeline {
    agent any

    environment {
        AWS_ACCESS_KEY_ID     = credentials('aws-access-key')
        AWS_SECRET_ACCESS_KEY = credentials('aws-secret-key')
        TF_DIR = '.'
        APP_IMAGE = 'node-app:latest'
    }

    stages {
        stage('Checkout') {
            steps {
                git 'https://github.com/raohus/terraform-node-ci.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh '''
                echo "Building Docker image..."
                docker build -t $APP_IMAGE .
                docker save $APP_IMAGE -o node-app.tar
                '''
            }
        }

        stage('Terraform Init') {
            steps {
                dir("${TF_DIR}") {
                    sh 'terraform init'
                }
            }
        }

        stage('Terraform Refresh') {
            steps {
                dir("${TF_DIR}") {
                    sh '''
                    echo "Refreshing Terraform state..."
                    terraform refresh
                    '''
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                dir("${TF_DIR}") {
                    sh '''
                    echo " Applying Terraform configuration..."
                    terraform apply -auto-approve
                    '''
                }
            }
        }

        stage('Deploy App via Terraform User Data') {
            steps {
                echo "✅ Terraform will install Docker & run the app automatically on EC2"
            }
        }
    }

    post {
        success {
            echo '🎉 Deployment successful! Visit the EC2 public IP output by Terraform.'
        }
        failure {
            echo '❌ Deployment failed.'
        }
    }
}
