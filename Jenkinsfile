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
                sh 'bin/docker-test-1'
              }
            },
            "Controllers" : {
              dir ('parallel') {
                sh 'bin/docker-test-2'
              }
            }
          )
        }
      }
    }
}
