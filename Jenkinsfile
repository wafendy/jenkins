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
            script {
              env.USER_INPUT = input id: "1", message: 'Deploy?', ok: 'Go Die!',parameters: [
                [$class: 'BooleanParameterDefinition', defaultValue: false, description: '', name: 'Please confirm you agree with this']
              ]
              echo env.USER_INPUT
            }
            milestone (30)
          }
        }
        stage ("Deploying") {
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
