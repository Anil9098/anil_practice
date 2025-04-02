node {

        try {
        
            stage('Hello') {
                echo 'Hello World'
            }

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

            stage('verify docker community') {
                sh "ansible-galaxy collection install community.docker"
            }
            
            stage('execute ansible') {
                ansiblePlaybook(
                    credentialsId: 'ansiblekey', 
                    disableHostKeyChecking: true, 
                    installation: 'ansible', 
                    inventory: 'ansible/inventory/inventory.ini', 
                    playbook: 'ansible/playbook.yml', 
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










