pipeline {
    agent { 'master' }
    stages {
        stage('build') {
            steps {
                sh 'ruby --version'
                sh 'docker --version'
            }
        }
    }
}
