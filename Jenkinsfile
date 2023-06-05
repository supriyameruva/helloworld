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
        echo "WebHook Is Successfull Change"
      }
    }
   stage('Build') {
      steps {
        echo '<--------------- Building --------------->'
        sh 'printenv'
        sh 'mvn -version'
        sh 'mvn clean install'
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
    stage('Sonar Analysis') {
      environment {
        scannerHome = tool 'sonar'
      }
      steps {
        echo '<--------------- Sonar Analysis started  --------------->'
                // withSonarQubeEnv('SonarServer') {
                //     sh "${scannerHome}/bin/sonar-scanner"

        // }
        withSonarQubeEnv('sonar') {
          sh 'mvn clean verify sonar:sonar -Dsonar.projectKey=Javaapp'
          echo '<--------------- Sonar Analysis stopped  --------------->'
        }
      }
    }
    stage('Quality Gate') {
      steps {
        script {
          echo '<--------------- Quality Gate started  --------------->'
          timeout(time: 1, unit: 'MINUTES') {
            def qg = waitForQualityGate()
            if (qg.status != 'OK') {
              error 'Pipeline failed due to the Quality gate issue'
            }
          }
          echo '<--------------- Quality Gate stopped  --------------->'
        }
      }
    }
  }
}
