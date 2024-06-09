pipeline {
    agent any

    environment {
        EC2_HOST = '3.148.109.254'  // IP of your EC2 instance
        SSH_KEY_ID = 'EC2-SSH-Key'  // SSH key credential ID
    }

    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'main', url: 'https://github.com/AmirParyenti/TerraformMission.git'
            }
        }

        stage('Deploy to AWS EC2') {
            steps {
                script {
                    sshagent([SSH_KEY_ID]) {
                        // Transfer files
                        sh "scp -o StrictHostKeyChecking=no index.html ubuntu@${EC2_HOST}:/var/www/html/index.html"
                        
                        // Restart Nginx to apply changes
                        sh "ssh -o StrictHostKeyChecking=no ubuntu@${EC2_HOST} 'sudo systemctl restart nginx'"
                    }
                }
            }
        }
    }
}
