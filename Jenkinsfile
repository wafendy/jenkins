#!groovy

pipeline {
    agent { label 'master' }
    stages {
      stage('checkout repo') {
        steps {
          checkout changelog: false, poll: false, scm: [$class: 'GitSCM', branches: [[name: "origin/single"]], doGenerateSubmoduleConfigurations: false, extensions: [[$class: 'RelativeTargetDirectory', relativeTargetDir: 'single']], submoduleCfg: [], userRemoteConfigs: [[url: 'https://github.com/wafendy/jenkins.git']]]
        }
      }
      stage('build') {
        steps {
          parallel (
            "Models" : {
              dir ('single') {
                sh 'bin/docker-test-1'
              }
            },
            "Controllers" : {
              dir ('single') {
                sh 'bin/docker-test-2'
              }
            }
          )
        }
      }
    }
}
