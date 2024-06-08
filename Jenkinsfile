pipeline {
    agent any

    environment {
        REPO_URL = 'https://github.com/AmirParyenti/TerraformMission.git'
        EC2_HOST = '3.148.109.254'  // IP of your EC2 instance
        SSH_KEY_ID = 'EC2-SSH-Key'  // SSH key credential ID
    }

    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'main', url: "$REPO_URL"
            }
        }

        stage('Transfer and Deploy to EC2') {
            steps {
                sshPublisher(
                    publishers: [
                        sshPublisherDesc(
                            configName: "$SSH_KEY_ID",
                            verbose: true,
                            transfers: [
                                sshTransfer(
                                    sourceFiles: 'index.html',
                                    removePrefix: 'src',  // Adjust this if your file is in a subdirectory
                                    remoteDirectory: '/usr/share/nginx/html/',  // Default directory for Nginx
                                    execCommand: """
                                        sudo systemctl restart nginx
                                    """
                                )
                            ]
                        )
                    ]
                )
            }
        }
    }
}
