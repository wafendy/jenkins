#!groovy

pipeline {
    agent { label 'master' }
    stages {
      stage('checkout repo') {
        steps {
          checkout changelog: false, poll: false, scm: [$class: 'GitSCM', branches: [[name: "origin/parallel"]], doGenerateSubmoduleConfigurations: false, extensions: [[$class: 'RelativeTargetDirectory', relativeTargetDir: 'parallel']], submoduleCfg: [], userRemoteConfigs: [[url: 'https://github.com/wafendy/jenkins.git']]]
        }
      }
      stage('build') {
        steps {
          parallel (
            "Models" : {
              dir ('parallel') {
                sh "docker-compose -p m.$env.BUILD_TAG -f docker-compose.yml build"
                sh "TEST_PIPE_NUMBER=models docker-compose -p m.$env.BUILD_TAG -f docker-compose.yml run app"
              }
            },
            "Controllers" : {
              dir ('parallel') {
                sh "docker-compose -p c.$env.BUILD_TAG -f docker-compose.yml build"
                sh "TEST_PIPE_NUMBER=controllers docker-compose -p c.$env.BUILD_TAG -f docker-compose.yml run app"
              }
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
