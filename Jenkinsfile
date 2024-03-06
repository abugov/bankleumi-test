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
                sh '/opt/homebrew/bin/terraform init'
            }
        }
        stage('Terraform apply') {
            steps {
                //sh './terraform apply --auto-approve'
                sh '/opt/homebrew/bin/aws --version && /opt/homebrew/bin/terraform plan'
            }
        }
    }
}