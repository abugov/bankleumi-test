pipeline {
    agent any
    // not setting auto-trigger to simplify solution. but if needed then i need to expose the Jenkins Server to internet and then setup a Github webhook using: https://docs.github.com/en/webhooks/using-webhooks/creating-webhooks#creating-a-repository-webhook
    stages {
        stage('Hello') {
            steps {
                echo 'Hello, world!'
            }
        }
    }
}