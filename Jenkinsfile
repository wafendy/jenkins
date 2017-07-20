#!groovy

pipeline {
  agent { label 'master' }
  stages {
    stage('build') {
      agent {
        docker {
          image 'ubuntu:16.04'
          reuseNode true
        }
      }
      steps {
        sh 'bin/docker-test'
      }
    }
  }
}
