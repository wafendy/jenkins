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
            // notifyAll(currentBuild.result)
          }
        }
      }

      // stage('Deploy?') {
      //   steps {
      //     notifyHipchat('READY')
      //
      //     timeout(time: 4, unit: 'HOURS') {
      //       input(id: env.GIT_REPO, message: 'Deploy to Staging?', ok: 'Deploy')
      //     }
      //   }
      //   post {
      //     success {
      //       notifyHipchat('SUCCESS')
      //     }
      //     failure {
      //       notifyHipchat('FAILURE')
      //     }
      //   }
      // }
    }
}

def notifyAll(String status) {
  notifyGithub(status.toLowerCase())
  notifyHipchat(status)
}

def notifyGithub(String buildStatus = 'pending') {
  // https://github.com/blog/1227-commit-status-api
  // https://developer.github.com/v3/repos/statuses/
  // Gist from https://github.com/jenkinsci/pipeline-examples/pull/21/files
  withCredentials([
    [$class: 'StringBinding', credentialsId: 'GITHUB_TOKEN', variable: 'GITHUB_TOKEN']
  ]) {
    // TODO Find a way to dynamically generate this url
    def url = "https://api.github.com/repos/binaries/$env.GIT_REPO/statuses/$env.GIT_COMMIT"
    def headers = "-H \"Content-Type: application/json\" -H \"Authorization: token $env.GITHUB_TOKEN\""
    def buildMessage = "[$buildStatus] Build #$env.BUILD_NUMBER"
    def postData = """{
      "state": "$buildStatus",
      "target_url": "$env.BUILD_URL",
      "description": "$buildMessage",
      "context": "jenkins"
    }"""

    sh "curl -s -X POST $headers -d '$postData' $url > /dev/null"
  }
}

def notifyHipchat(String buildStatus = 'PENDING', String overrideMessage = "") {
  withCredentials([
    [$class: 'StringBinding', credentialsId: 'POBLANO_HIPCHAT_TOKEN', variable: 'POBLANO_HIPCHAT_TOKEN']
  ]) {
    def color = 'YELLOW'
    def message = overrideMessage

    if (message.trim() == "") {
      def commit_message = "<a href=\"https://github.com/binaries/$env.GIT_REPO/commit/$env.GIT_COMMIT\">$env.GIT_COMMIT_SHORT</a>"
      message = """
        <b>[$buildStatus] <a href=\"$env.JOB_URL\">$env.JOB_NAME</a> <a href=\"$env.BUILD_URL\">#$env.BUILD_NUMBER</a></b>
        <br />
        $commit_message - $env.GIT_MESSAGE
      """
    }

    if (buildStatus == 'SUCCESS') {
      color = 'GREEN'
    } else if (buildStatus == 'FAILURE') {
      color = 'RED'
    }

    hipchatSend(color: color,
                notify: true,
                message: message,
                room: '740604',
                token: env.POBLANO_HIPCHAT_TOKEN,
                v2enabled: true)
  }
}
