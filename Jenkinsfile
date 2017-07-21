#!groovy

pipeline {
    agent { label 'master' }
    environment {
        AGENT               = 'jenkins-us-east-node-with-docker'
        AWS_DEFAULT_REGION  = 'us-east-1'
        GIT_REPO            = 'poblano'
        STAGING_URL         = 'https://pob-stag1-console.pm-staging.net'
        GIT_COMMIT          = sh(returnStdout: true, script: 'git rev-parse HEAD').trim()
        GIT_COMMIT_SHORT    = sh(returnStdout: true, script: 'git rev-parse --short HEAD').trim()
        GIT_MESSAGE         = sh(returnStdout: true, script: "git --no-pager show -s --format='%s (%an <%ae>)' ${GIT_COMMIT}").trim()
    }
    stages {
      stage('Prepare') {
        steps {
          script {
            checkout scm
            sh 'git rev-parse HEAD > GIT_COMMIT'
            // TODO Deprecate this when Maven supports GIT_COMMIT as global variable
            GIT_COMMIT = readFile('GIT_COMMIT').trim()
            sh 'git rev-parse --short HEAD > GIT_COMMIT_SHORT'
            GIT_COMMIT_SHORT = readFile('GIT_COMMIT_SHORT').trim()
            sh "git --no-pager show -s --format='%s (%an <%ae>)' ${GIT_COMMIT} > GIT_MESSAGE"
            GIT_MESSAGE = readFile('GIT_MESSAGE').trim()
            sh 'export GGIT_COMMIT=BALLS'
            GIT_COMMIT_3 = sh 'git rev-parse HEAD'
          }
        }
      }
      stage('Print ENV') {
        steps {
          sh 'env | sort'
        }
      }
      stage('Build') {
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
