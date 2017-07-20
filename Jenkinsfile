pipeline {
    agent {
      node {
        label 'master'
      }
    }
    stages {
        stage('build') {
            steps {
                sh 'ruby --version'
                sh 'docker --version'
            }
        }
    }
}
