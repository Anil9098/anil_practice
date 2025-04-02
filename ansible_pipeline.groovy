node {

        try {
        
            stage('Hello') {
                echo 'Hello World'
            }

            stage('git clone') {
                sh "git clone https://github.com/Anil9098/anil_practice.git"
            }

            stage('ansible version') {
                sh "ansible --version"
            }

            stage('execute ansible') {
                ansiblePlaybook(
                    credentialsId: 'ansiblekey', 
                    disableHostKeyChecking: true, 
                    installation: 'ansible', 
                    inventory: 'anil_practice/ansible_project/inventory.ini', 
                    playbook: 'anil_practice/ansible_project/deploy.yml', 
                    vaultTmpPath: ''
                )
            }

        } catch (Exception e) {
            currentBuild.result = 'FAILURE'
            throw e
        } finally {
            // Notify or handle any post-process, like sending notifications
            if (currentBuild.result == 'SUCCESS') {
                echo 'Deployment was successful!'
            } else {
                echo 'Deployment failed!'
            }
    }
}










