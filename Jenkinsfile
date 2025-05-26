
pipeline {
    agent any 
        environment {
            AWS_region = "us-east-1"
	    AWS_ACCESS_KEY_ID     = credentials('AWS_ACCESS_KEY_ID')
            AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_KEY_ID')
        choice(
            name: 'ENVIRONMENT',
            choices: ['EC2', 'POSTGRES'],
            description: 'Choose which module to deploy'
        )	
  }
if (params.ENVIRONMENT == 'POSTGRES') {	
    stages  {
	stage('git checkout') {
		steps {
			script {
			  git branch: 'main', url: 'https://github.com/ckatPrakash/terraform_jenkins_demo.git'
			
		}
	}
	}		
	stage ('Terraform Init') {
		steps {
			sh 'terraform init'
		}
	}
	stage ('Terraform plan') {
		steps {
			sh 'terraform plan -out tfplan'
		}
	}
	 
	stage('User Confirmation') {
            steps {
                script {
                    def userChoice = input message: 'Choose Terraform action:', parameters: [
                        choice(name: 'action', choices: ['apply', 'destroy'], description: 'Select action')
                    ]
                    env.USER_ACTION = userChoice
                }
            }
        }
	stage ('Terraform apply/destroy') {
		steps {
			script {
			input message: "Are you sure you want to '${env.USER_ACTION}'?" 
			if (env.USER_ACTION == 'apply'){
			sh 'terraform apply -input=false -auto-approve -lock=false tfplan -target=module.Postgres_Database'
			}
			if (env.USER_ACTION == 'destroy') {
			sh 'terraform destroy -auto-approve -target=module.Postgres_Database'
			}	
		}
	}
	}	
}
}
	
}
