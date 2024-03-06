pipeline {
    agent any
    
    parameters {
        string(name: 'TERRAFORM_BINARY', defaultValue: '/opt/homebrew/bin/terraform', description: 'full path to terraform bin')
    }

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
        stage('Build Lambda') {
            steps {
                sh "sed 's/BUILD_NUMBER/${BUILD_NUMBER}/g' lambda_template.txt > index.mjs"
            }
        }
        stage('Terraform init') {
            steps {
                sh "${params.TERRAFORM_BINARY} init"
            }
        }
        stage('Terraform apply') {
            steps {
                //sh '/opt/homebrew/bin/aws --version && ${params.TERRAFORM_BINARY} plan'
                sh "${params.TERRAFORM_BINARY} apply --auto-approve"
            }
        }
    }
}