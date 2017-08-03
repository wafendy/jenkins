#!groovy

pipeline{
    agent none
    stages{
        stage ("Build"){
            milestone(1)
            sleep getTime()
            echo "finishing build"
        }
        stage ("Test"){
            milestone (10)
            sleep getTime()
            echo "finishing Test"
        }
        stage ("Deploy"){
            milestone (20)
            sleep getTime()
            echo "finishing Deploy"
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
