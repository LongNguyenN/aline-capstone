pipeline {
    agent any
    environment {
        AWS_ACCESS_KEY_ID     = credentials('ln-aws-id')
        AWS_SECRET_ACCESS_KEY = credentials('ln-aws-key')
        SERVICE_ENV = credentials('ln-env')
	TERRAFORM_SECRET = credentials('ln-terraform-secret')
    }
    stages {
        stage('ECS') {
            steps {
	    	echo "Starting ECS.."
		//sh "bash ./ecs-up.sh"
	    }
	}
        stage('EKS') {
            steps {
	    	echo "Starting EKS.."
		//sh "bash ./eks-up.sh"
            }
        }
        stage('TERRAFORM') {
            steps {
	    	echo "Starting TERRAFORM.."
		//sh "bash ./terraform-up.sh"
            }
        }
    }
    post {
        always {
            cleanWs()
        }
    }
}
