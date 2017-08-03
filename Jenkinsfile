#!groovy

pipeline {
    agent none
    environment {
        AGENT               = 'jenkins-us-east-node-with-docker'
        AWS_DEFAULT_REGION  = 'us-east-1'
        GIT_REPO            = 'poblano'
        CLEAN_JOB_NAME      = JOB_NAME.replace("/", "-").replace("%2F", "-")
        STAGING_URL         = 'https://pob-stag1-console.pm-staging.net'
        GIT_COMMIT          = sh(returnStdout: true, script: 'git rev-parse HEAD').trim()
        GIT_COMMIT_SHORT    = sh(returnStdout: true, script: 'git rev-parse --short HEAD').trim()
        GIT_MESSAGE         = sh(returnStdout: true, script: 'git --no-pager show -s --format="%s (%an <%ae>) %H"').trim()
        CUSTOM_TAG          = "${GIT_REPO}-${GIT_COMMIT_SHORT}-${BUILD_NUMBER}"
    }
    stages {
      stage('Build') {
        agent { label 'master' }
        steps {
          sh "docker build . -t app.$env.BUILD_TAG"
        }
      }
      stage('Prepare DB') {
        agent { label 'master' }
        steps {
          sh "docker network create -d bridge net.$env.BUILD_TAG"
          sh "docker run --network net.$env.BUILD_TAG --network-alias mysqldb --name mysql.$env.BUILD_TAG -e MYSQL_ROOT_PASSWORD=secret -d mysql:5.6.28"
          sh "docker run --rm --network net.$env.BUILD_TAG app.$env.BUILD_TAG bin/wait-for-mysql"
        }
      }
      stage('Test') {
        agent { label 'master' }
        steps {
          parallel (
            "Models" : {
              sh "docker run --rm --network net.$env.BUILD_TAG -e RAILS_ENV=test app.$env.BUILD_TAG bin/test models"
            },
            "Controllers" : {
              sh "docker run --rm --network net.$env.BUILD_TAG -e RAILS_ENV=test app.$env.BUILD_TAG bin/test controllers"
            },
            "Integration" : {
              sh "docker run --rm --network net.$env.BUILD_TAG -e RAILS_ENV=test app.$env.BUILD_TAG bin/test integration"
            },
            "Mailers" : {
              sh "docker run --rm --network net.$env.BUILD_TAG -e RAILS_ENV=test app.$env.BUILD_TAG bin/test mailers"
            },
            "System" : {
              sh "docker run --rm --network net.$env.BUILD_TAG -e RAILS_ENV=test app.$env.BUILD_TAG bin/test system"
            }
          )
        }
      }
      stage('Deploy?') {
        agent none
        steps {
          milestone 1
          script {
            env.RELEASE_SCOPE = input message: 'User input required', ok: 'Release!',
                                      parameters: [choice(name: 'RELEASE_SCOPE', choices: 'patch\nminor\nmajor', description: 'What is the release scope?')]
          }
          milestone 2
        }
      }
      stage('Deploy to Staging') {
        agent { label 'master' }
        when {
          not { branch 'master' } //Safety
          expression { env.RELEASE_SCOPE == 'patch' }
        }
        steps {
          echo 'Deploying to Staging'
        }
      }
    }

    post {
      always {
        node('master') {
          steps{
            sh "docker container rm -fv mysql.$env.BUILD_TAG"
            sh "docker image rm app.$env.BUILD_TAG"
            sh "docker network rm net.$env.BUILD_TAG"
          }
        }
      }
    }
}
