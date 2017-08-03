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
        stage ("Deploy"){
          steps {
            milestone (20)
            input id: 1, message: 'Deploy?', ok: 'Go Die!'
            echo "finishing Deploy"
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
