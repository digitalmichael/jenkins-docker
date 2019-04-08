pipeline {

  environment {
    registry = "docker_hub_account/repository_name"
    registryCredential = 'dockerhub'
  }

agent any
//    agent {
//       docker { image 'node:7-alpine' }
//   }

  stages {
    stage('Cloning Git') {
      steps {
        git 'https://github.com/laradock/laradock.git'
      }
    }
    stage('Fetch dependencies') {
        /* This stage pulls the latest nginx image from
           Dockerhub */
      steps {
          sh 'sudo docker pull nginx:latest'
      }
    }
    stage('Build image') {
      steps {
           echo 'Starting to build docker image'
           sh 'pwd'
           sh "sudo docker build nginx -t ${env.JOB_NAME}:${env.BUILD_ID} --no-cache"

          // uncomment when you want to build and push to a remote registry
          // script {
          //   def customImage = docker.build("nginx-docker:${env.BUILD_ID}", "nginx")
          //   //customImage.push()
          // }
        }
      }
    stage('Test image') {
         /* This stage runs unit tests on the image; we are
            just running dummy tests here */
       steps {
            sh 'echo "Tests successful"'
      }
    }
  }
}
