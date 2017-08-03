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
        stage ("Promote"){
          steps {
            milestone (20)
            script {
              env.USER_INPUT = input id: "1", message: 'Deploy?', ok: 'Go Die!'
            }
            milestone (30)
            echo "finishing Deploy ${env.USER_INPUT}"
          }
        }
        stage ("Deploying") {
          when { expression { env.USER_INPUT == 'Proceed' } }
          steps {
            echo "Deploying to staging"
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
