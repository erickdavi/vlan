pipeline {
  agent any
  stages {
    stage('build') {
      steps {
        parallel(
          "build": {
            sh 'ls -l'
            
          },
          "testando": {
            sh './vcmd list'
            
          }
        )
      }
    }
  }
}