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

        stage('Transfer and Deploy to EC2') {
            steps {
                sshPublisher(
                    publishers: [
                        sshPublisherDesc(
                            configName: "EC2 SSH",  // Name of the SSH server configuration in Jenkins
                            transfers: [
                                sshTransfer(
                                    sourceFiles: '**/*.html',  // Adjust based on what needs to be transferred
                                    removePrefix: 'src',  // Adjust if your file is in a subdirectory
                                    remoteDirectory: '.',  // Adjust based on where you want files on the server
                                    execCommand: 'sudo systemctl restart nginx'
                                )
                            ]
                        )
                    ]
                )
            }
        }
    }
}
