pipeline {
	agent any
	environment {
		DEV_DESTROY = "YES"
		PROD_DESTROY = "YES"
	}

	stages {
		stage('Checking EKS Access') {
			steps {
				withAWS(credentials: 'aws-creds') {
					sh 'aws eks update-kubeconfig --region us-east-1  --name eks-cluster'
					sh 'kubectl get pods -A'
				}
			}
		}

		stage('Creating EKS Namespaces') {
			steps {
				withAWS(credentials: 'aws-creds') {
					sh 'aws eks update-kubeconfig --region us-east-1  --name eks-cluster'
					sh 'kubectl create ns development || exit 0'
					sh 'kubectl create ns production || exit 0'
				}
			}
		}

		stage('Deploy To Dev Namespace') {
			when {
				branch 'development'
			}

			steps {
				withAWS(credentials: 'aws-creds') {
					sh 'aws eks update-kubeconfig --region us-east-1  --name eks-cluster'
					sh 'ls -al'
					sh 'kustomize build kustomize/overlays/development'
					sh 'kubectl apply -k kustomize/overlays/development'
					sh 'kubectl get pods,deploy,svc -n development'
				}
			}
		}

		stage('Destroy App In Dev Namespace') {
			when {
				expression {
					"${env.PROD_DESTROY}" == 'YES' && "$BRANCH_NAME" == 'development'
				}
			}

			steps {
				withAWS(credentials: 'aws-creds') {
					sh 'aws eks update-kubeconfig --region us-east-1  --name eks-cluster'
					sh 'ls -al'
					sh 'kubectl delete -k kustomize/overlays/development'
					sh 'kubectl get pods,deploy,svc -n development'
				}
			}
		}

		stage('Deploy To Prod Namespace') {
			when {
				branch 'production'
			}

			steps {
				withAWS(credentials: 'aws-creds') {
					sh 'aws eks update-kubeconfig --region us-east-1  --name eks-cluster'
					sh 'ls -al'
					sh 'kustomize build kustomize/overlays/production'
					sh 'kubectl apply -k kustomize/overlays/production'
					sh 'kubectl get pods,deploy,svc -n production'
				}
			}
		}

		stage('Destroy App In Prod Namespace') {
			when {
				expression {
					"${env.PROD_DESTROY}" == 'YES' && "$BRANCH_NAME" == 'production'
				}
			}

			steps {
				withAWS(credentials: 'aws-creds') {
					sh 'aws eks update-kubeconfig --region us-east-1  --name eks-cluster'
					sh 'ls -al'
					sh 'kubectl delete -k kustomize/overlays/production'
					sh 'kubectl get pods,deploy,svc -n production'
				}
			}
		}
	}
}
