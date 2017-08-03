#!groovy

pipeline{
    agent none
    stages{
        stage ("Build"){
          steps {
            milestone(1)
            sleep getTime()
            echo "finishing build"
          }
        }
        stage ("Test"){
          steps {
            milestone (10)
            sleep getTime()
            echo "finishing Test"
          }
        }
        stage ("Promote?"){
          steps {
            milestone (20)
            timeout(time: 10, unit: 'SECONDS') {
              input message: 'Deploy?', ok: 'Go Die!'
            }
            milestone (30)
          }
        }
        stage ("Deploying") {
          steps {
            echo "=================================="
            echo "==============Deploying to staging"
            echo "=================================="
          }
        }
    }
}



@NonCPS
def getTime() {
    if (currentBuild.number % 2 != 0){
        return 10
    }
    else{
        return 5
    }
}
