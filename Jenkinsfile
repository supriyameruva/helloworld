def imageName = 'sonatypenexus/helloworld'
def registry  = 'http://20.163.196.201:9091/repository/docker/'
def version   = '1.0.2'
pipeline {
  agent any
  stages {
    stage('Checkout') {
      steps {
        git branch: 'main', url: 'https://github.com/bkrraj/hello-world.git'
      }
    }
    stage('Pull Changes') {
      steps {
        sh 'git pull main'
      }
    }
    stage('Build') {
      steps {
        echo '<--------------- Building --------------->'
        sh 'printenv'
        sh '/opt/apache-maven/bin/mvn clean install'
        echo '<------------- Build completed --------------->'
      }
    }
    stage('Unit Test') {
      steps {
        echo '<--------------- Unit Testing started  --------------->'
        sh '/opt/apache-maven/bin/mvn surefire-report:report'
        echo '<------------- Unit Testing stopped  --------------->'
      }
    }
    stage('Sonar Analysis') {
      environment {
        scannerHome = tool 'SonarQubeScanner'
      }
      steps {
        echo '<--------------- Sonar Analysis started  --------------->'
                // withSonarQubeEnv('SonarServer') {
                //     sh "${scannerHome}/bin/sonar-scanner"

        // }
        withSonarQubeEnv('SonarQubeScanner') {
          sh '/opt/apache-maven/bin/mvn clean verify sonar:sonar -Dsonar.projectKey=helloworld'
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

    stage(' Docker Build ') {
          steps {
            script {
          echo '<--------------- Docker Build Started --------------->'
          app = docker.build(imageName + ':' + version)
          echo '<--------------- Docker Build Ends --------------->'
            }
          }
    }

    stage('Upload to Nexus') {
      steps {
        script {
           echo '<--------------- War Publish Started --------------->'
          nexusArtifactUploader artifacts: [
            [artifactId: 'webapp', classifier: '', file: 'webapp/target/webapp.war', type: 'war']
            ], credentialsId: 'nexus', groupId: 'com.example.maven-project', nexusUrl: '20.163.196.201:8081', nexusVersion: 'nexus3', protocol: 'http', repository: 'mavenrepo', version: '1.0'
            echo '<--------------- War Publish Ended --------------->'  
          
        }
      }
	}

     stage (" Docker Publish "){
            steps {
                script {
                   echo '<--------------- Docker Publish Started --------------->'  
                    docker.withRegistry(registry, 'dockerregistry'){
                        app.push()
                    }    
                   echo '<--------------- Docker Publish Ended --------------->'  
                }
            }
        }
      
         
         stage(" Deploy ") {
          steps {
            script {
               echo '<--------------- Deploy Started --------------->'
               deploy adapters: [tomcat9(credentialsId: 'tomcat', path: '', url: 'http://ec2-23-23-60-109.compute-1.amazonaws.com:8080')], contextPath: null, war: '**/*.war'
               echo '<--------------- Deploy Ends --------------->'
            }
          }
        } 
}
}
