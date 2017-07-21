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
        GIT_MESSAGE         = sh(returnStdout: true, script: 'git --no-pager show -s --format="%s (%an <%ae>) %H"').trim()
    }
    stages {
      // Another way to set ENV variables
      // stage('Prepare') {
      //   steps {
      //     script {
      //       env.TESTING1 = 'hello'
      //       env.TESTING2 = 'hello there'
      //     }
      //   }
      // }
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

      stage('Deploy?') {
        steps {
          notifyHipchat('READY')

          timeout(time: 4, unit: 'HOURS') {
            input(id: env.GIT_REPO, message: 'Deploy to Staging?', ok: 'Deploy')
          }
        }
        post {
          success {
            notifyHipchat('SUCCESS')
          }
          failure {
            notifyHipchat('FAILURE')
          }
        }
      }
    }
}

def notifyHipchat(String buildStatus) {
  echo "[$buildStatus] HELLO THERE ++++++++++++++++++++++++++++++++++++++"
  echo "[$buildStatus] HELLO THERE ++++++++++++++++++++++++++++++++++++++"
  echo "[$buildStatus] HELLO THERE ++++++++++++++++++++++++++++++++++++++"
  echo "[$buildStatus] HELLO THERE ++++++++++++++++++++++++++++++++++++++"
  echo "[$buildStatus] HELLO THERE ++++++++++++++++++++++++++++++++++++++"
  echo "[$buildStatus] HELLO THERE ++++++++++++++++++++++++++++++++++++++"
  echo "[$buildStatus] HELLO THERE ++++++++++++++++++++++++++++++++++++++"
  echo "[$buildStatus] HELLO THERE ++++++++++++++++++++++++++++++++++++++"
}
