pipeline {
    agent any
    
    environment {
        AWS_ACCESS_KEY_ID     = credentials('aws-secret-key-id')
        AWS_SECRET_ACCESS_KEY = credentials('aws-secret-access-key')
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'master', url: 'https://github.com/abugov/bankleumi-test'
            }
        }
        stage('Terraform init') {
            steps {
                sh '/opt/homebrew/bin/terraform init'
            }
        }
        stage('Terraform apply') {
            steps {
                //sh '/opt/homebrew/bin/aws --version && /opt/homebrew/bin/terraform plan'
                sh '/opt/homebrew/bin/terraform apply --auto-approve'
            }
        }
    }
}