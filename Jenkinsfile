pipeline {
    agent any

    environment {
        DOCKERHUB_CREDENTIALS_ID = 'dockerhub'  // Dockerhub credentials ID
        AWS_CREDENTIALS_ID = 'AWS Amir IAM'  // AWS credentials ID
        EC2_HOST = '3.148.109.254'  // IP of your EC2 instance
        REPO_URL = 'https://github.com/AmirParyenti/TerraformMission.git'  // Your GitHub Repo URL
        SSH_KEY_ID = 'EC2-SSH-Key'  // SSH key credential ID
    }

    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'main', url: "$REPO_URL"
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    docker.build("amirparyenti/myapp:${env.BUILD_ID}")
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    docker.withRegistry('', "$DOCKERHUB_CREDENTIALS_ID") {
                        docker.image("amirparyenti/myapp:${env.BUILD_ID}").push()
                    }
                }
            }
        }

        stage('Deploy to AWS EC2') {
            steps {
                sshPublisher(
                    publishers: [
                        sshPublisherDesc(
                            configName: "$SSH_KEY_ID",
                            transfers: [
                                sshTransfer(
                                    sourceFiles: "docker-compose.yml",
                                    removePrefix: "dist",
                                    remoteDirectory: "/home/ubuntu/",
                                    execCommand: """
                                        docker pull amirparyenti/myapp:${env.BUILD_ID}
                                        docker-compose -f /home/ubuntu/docker-compose.yml up -d
                                    """
                                )
                            ],
                            execCommand: "echo Deployment completed successfully"
                        )
                    ]
                )
            }
        }
    }
}
