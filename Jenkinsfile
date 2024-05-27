pipeline {
    agent any

    stages {
        stage('Clone Repository') {
            steps {
                git 'https://your-repository-url.git'
            }
        }
        stage('Build Docker Image') {
            steps {
                script {
                    docker.build("my-nginx:${env.BUILD_ID}")
                }
            }
        }
        stage('Push Image to Registry') {
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', 'docker-hub-credentials') {
                        docker.image("my-nginx:${env.BUILD_ID}").push()
                    }
                }
            }
        }
        stage('Deploy to AWS EC2') {
            steps {
                withCredentials([aws(accessKeyVariable: 'AWS_ACCESS_KEY_ID', credentialsId: 'Amir', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY')]) {
                    sshagent(['ec2-ssh-key']) {
                        sh "ssh -o StrictHostKeyChecking=no ec2-user@your-ec2-public-dns 'docker pull my-nginx:${env.BUILD_ID}'"
                        sh "ssh -o StrictHostKeyChecking=no ec2-user@your-ec2-public-dns 'docker stop web || true && docker rm web || true'"
                        sh "ssh -o StrictHostKeyChecking=no ec2-user@your-ec2-public-dns 'docker run -d --name web -p 80:80 my-nginx:${env.BUILD_ID}'"
                    }
                }
            }
        }
    }
    post {
        always {
            cleanWs()
        }
    }
}
