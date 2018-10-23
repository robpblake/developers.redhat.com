pipeline {
    agent any
    stages {
        stage('Build Docker Image') {
            steps {
                def drupalDockerImage = docker.build("redhatdeveloper/rhdp-drupal:${env.BUILD_ID}", "./_docker/drupal")
            }
        }
    }
}