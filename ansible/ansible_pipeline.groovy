node {
    try {
        withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws_credentials']]) {
        
            stage('git clone') {
                checkout([$class: 'GitSCM',
                    branches: [[name: '*/master']],  
                    userRemoteConfigs: [[
                        url: "https://github.com/Anil9098/anil_practice.git",
                        credentialsId: "gitCredentialsId"		
                    ]]
                ])
            }

            stage('ansible version') {
                sh "ansible --version"
            }

            stage('verify aws plugin') {
                sh "ansible-galaxy collection install amazon.aws"
            }

            stage('aws CLI verification') {
                sh "aws --version"
            }

            stage('execute ansible') {
                ansiblePlaybook(
                    credentialsId: 'ansiblekey', 
                    disableHostKeyChecking: true, 
                    installation: 'ansible', 
                    inventory: 'ansible/inventory/aws/aws_ec2.yml', 
                    playbook: 'ansible/playbook.yml', 
                    vaultTmpPath: ''
                )
            }
        }

    } catch (Exception e) {
        currentBuild.result = 'FAILURE'
        throw e
    } finally {
        echo "pipeline completd"
    }      
}


























