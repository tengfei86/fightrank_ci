// Uses Declarative syntax to run commands inside a container.
pipeline {
    agent {
        kubernetes {
            // Rather than inline YAML, in a multibranch Pipeline you could use: yamlFile 'jenkins-pod.yaml'
            // Or, to avoid YAML:
            // containerTemplate {
            //     name 'shell'
            //     image 'ubuntu'
            //     command 'sleep'
            //     args 'infinity'
            // }
            yaml '''
apiVersion: v1
kind: Pod
spec:
  containers:
  - name: shell
    image: ubuntu
    command:
    - sleep
    args:
    - infinity
    securityContext:
      # ubuntu runs as root by default, it is recommended or even mandatory in some environments (such as pod security admission "restricted") to run as a non-root user.
      runAsUser: 1000
  - name: kaniko
    image: daocloud.io/gcr-mirror/kaniko-project-executor:latest
    args:
    - --dockerfile=/workspace/Dockerfile
    - --context=dir:///workspace
    - --destination=blade2gt/rainfall-backend:v1.0
    env:
    - name: DOCKER_CONFIG
      value: /kaniko/.docker
    volumeMounts:
    - name: kaniko-secret
      mountPath: /kaniko/.docker
  volumes:
  - name: kaniko-secret
    secret:
      secretName: docker-registry-credentials
'''
            // Can also wrap individual steps:
            // container('shell') {
            //     sh 'hostname'
            // }
            defaultContainer 'shell'
            retries 2
        }
    }
    stages {
        stage('Pull from Secondary Git Repository') {
         steps {
             script {
                 git branch: 'main', 
                     url: 'https://gitee.com/jonasyeah/waterloggingforcast.git'
             }
         }
        }
        stage('Main') {
            steps {
                sh 'ls -l'
                sh 'hostname'
            }
        }
    }
}

