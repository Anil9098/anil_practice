node {
    // Define environment variables
    def repoUrl = 'https://github.com/Anil9098/anil_practice.git'
    //def appDir = '/home/ubuntu/anil_practice'
    //def scriptDir = '/home/ubuntu/anil_practice/bash'
    def deployScript = 'example_deployment.sh'
    def ansiblePlaybook = 'deploy.yml'
    //def inventoryFile = 'inventory.ini'


    try {
        stage('Preparation') {
            echo 'Starting deployment process with Ansible'
            echo "ansible --version"
        }

        stage('Run Ansible Playbook') {
            echo 'Running the Ansible Playbook'

            // Run the Ansible playbook to handle the deployment
            sh "ansible-playbook ${deploy.yml}"
        }

        stage('Post-Deployment') {
            echo 'Deployment process completed.'
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












