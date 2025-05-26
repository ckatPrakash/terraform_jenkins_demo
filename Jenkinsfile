
pipeline {
    agent any 
    parameters {
        choice(name: 'TERRAFORM_MODULE', choices: ['EC2', 'Postgres'], description: 'Select the Terraform module to deploy')
    }	
        environment {
            AWS_region = "us-east-1"
	    AWS_ACCESS_KEY_ID     = credentials('AWS_ACCESS_KEY_ID')
            AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_KEY_ID')

 	 }
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
		 script {
                    if (params.TERRAFORM_MODULE == 'EC2') {
                        echo "Running terraform plan for EC2"
			sh 'terraform plan -input=false -lock=false -target=module.EC2_Instance -out=tfplan'    
		    }
                    if (params.TERRAFORM_MODULE == 'Postgres') {
                        echo "Running terraform plan for Postgres"
			sh 'terraform plan -input=false -lock=false -target=module.Postgres_Database -out=tfplan'
		    }

		 }
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
			if (env.USER_ACTION == 'apply' && params.TERRAFORM_MODULE == 'Postgres'){
			sh 'terraform apply -input=false -auto-approve -lock=false tfplan'
			}
			if (env.USER_ACTION == 'destroy' && params.TERRAFORM_MODULE == 'Postgres') {
			sh 'terraform destroy -auto-approve -target=module.Postgres_Database'
			}
			if (env.USER_ACTION == 'apply' && params.TERRAFORM_MODULE == 'EC2'){
			sh 'terraform apply -input=false -auto-approve -lock=false tfplan'
			}
			if (env.USER_ACTION == 'destroy' && params.TERRAFORM_MODULE == 'EC2') {
			sh 'terraform destroy -auto-approve -target=module.EC2_Instance'
			}				
		}
	}
	}	
}
}

	

