#!groovy

pipeline {
    agent { docker 'ruby' }
    stages {
        stage('build') {
            steps {
                parallel (
                    "Models" : {
                        bin/rails test test/models
                    },
                    "Controllers" : {
                        bin/rails test test/controllers
                    }
                )
            }
        }
    }
    post {
        success {
            echo 'This will run only if successful'
        }
        failure {
            echo 'This will run only if failed'
        }
        unstable {
            echo 'This will run only if the run was marked as unstable'
        }
        changed {
            echo 'This will run only if the state of the Pipeline has changed'
            echo 'For example, if the Pipeline was previously failing but is now successful'
        }
        always {
            echo 'This will always run'
        }
    }
}
