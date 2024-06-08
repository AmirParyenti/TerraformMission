pipeline {
    agent any

    stages {
        stage('Clone Repository') {
            steps {
                git 'https://github.com/AmirParyenti/TerraformMission.git'
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
                withCredentials([aws(accessKeyVariable: 'AWS_ACCESS_KEY_ID', credentialsId: 'sam-jenkins-demo-credentials', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY')]) {
                    sshagent(['amir-ec2-ssh']) {
                        sh "ssh -o StrictHostKeyChecking=no ec2-user@147.235.217.29 'docker pull my-nginx:${env.BUILD_ID}'"
                        sh "ssh -o StrictHostKeyChecking=no ec2-user@147.235.217.29 'docker stop web || true && docker rm web || true'"
                        sh "ssh -o StrictHostKeyChecking=no ec2-user@147.235.217.29 'docker run -d --name web -p 80:80 my-nginx:${env.BUILD_ID}'"
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
