#!groovy

pipeline {
    agent { label 'master' }
    environment {
        AGENT               = 'jenkins-us-east-node-with-docker'
        AWS_DEFAULT_REGION  = 'us-east-1'
        GIT_REPO            = 'poblano'
        STAGING_URL         = 'https://pob-stag1-console.pm-staging.net'
    }
    stages {
      stage('init') {
        steps {
          checkout scm
          sh 'git rev-parse HEAD > GIT_COMMIT'
          // TODO Deprecate this when Maven supports GIT_COMMIT as global variable
          env.GIT_COMMIT = readFile('GIT_COMMIT').trim()
          sh 'git rev-parse --short HEAD > GIT_COMMIT_SHORT'
          env.GIT_COMMIT_SHORT = readFile('GIT_COMMIT_SHORT').trim()
          sh "git --no-pager show -s --format='%s (%an <%ae>)' $env.GIT_COMMIT > GIT_MESSAGE"
          env.GIT_MESSAGE = readFile('GIT_MESSAGE').trim()

          sh 'env | sort'
        }
      }
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
