pipeline {
    agent any
    
    stages {
        stage('Checkout') {
            steps {
                git branch: 'master', url: 'https://github.com/abugov/bankleumi-test'
            }
        }
        stage('Terraform init') {
            steps {
                sh 'chmod +x terraform && terraform init'
            }
        }
        stage('Terraform apply') {
            steps {
                //sh 'terraform apply --auto-approve'
                sh 'terraform plan'
            }
        }
    }
}