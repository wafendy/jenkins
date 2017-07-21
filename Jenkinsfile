#!groovy

pipeline {
    agent { label 'master' }
    stages {
      stage('build') {
        steps {
          parallel (
            "Models" : {
              sh "docker-compose -p m.$env.BUILD_TAG -f docker-compose.yml build"
              sh "TEST_PIPE_NUMBER=models docker-compose -p m.$env.BUILD_TAG -f docker-compose.yml run app"
            },
            "Controllers" : {
              sh "docker-compose -p c.$env.BUILD_TAG -f docker-compose.yml build"
              sh "TEST_PIPE_NUMBER=controllers docker-compose -p c.$env.BUILD_TAG -f docker-compose.yml run app"
            }
          )
        }
        post {
          always {
            sh "docker-compose -p m.$env.BUILD_TAG -f docker-compose.yml down -v"
            sh "docker-compose -p c.$env.BUILD_TAG -f docker-compose.yml down -v"
          }
        }
      }
    }
}
