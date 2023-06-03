pipeline {
  agent any
  stages {
    stage('Checkout') {
      steps {
        git branch: 'main', url: 'git@github.com:bkrraj/helloworld.git'
      }
    }
    stage('Pull Changes') {
      steps {
        sh 'git pull origin main'
        echo "WebHook Is Successfull"
      }
    }
    stage('Build') {
      steps {
        echo '<--------------- Building --------------->'
        sh 'printenv'
        
        echo '<------------- Build completed --------------->'
       }
     }
    stage('Unit Test') {
      steps {
        echo '<--------------- Unit Testing started  --------------->'
        sh 'mvn surefire-report:report'
        echo '<------------- Unit Testing stopped  --------------->'
      }
    }
  }
}
