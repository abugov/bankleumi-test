# General comments and assumptions
1. i've put terraform in one file to save me time, in practice i would split into multiple files: variables.tf, outputs.tf, api-gateway.tf ...

2. i've based my terraform solution on: https://registry.terraform.io/providers/hashicorp/aws/2.34.0/docs/guides/serverless-with-aws-lambda-and-api-gateway

3. to simplify terraform integration and save me time (since i am running jenkins on mac) i am using TERRAFORM_BINARY param, in real-life scenario i would use the terraform plugin as described https://spacelift.io/blog/terraform-jenkins

4. Assumption #1: pipeline is run only once
	* I assumed there is no need to support re-run.
	* in real-life scenario i would have implemented this differently to support updates of the lambda-code as such:
		* add another lambda named "refresh lambda" to terraform, which is responsible to update the code of the original lambda. using "aws_s3_bucket_notification" i will trigger the "refresh lambda"
			* see "Lambda Auto-Deployer" here: https://aws.amazon.com/blogs/compute/new-deployment-options-for-aws-lambda/
		* Jenkins will do the following:
			* build the lambda code
			* run terraform (from the 2nd run there will be no changes to apply)
			* upload lambda to S3 (this will trigger the "refresh lambda")
		* setup Github webhook to auto-trigger the pipeline when the code changes
			* use 'when { changeset "index.mjs" }' to trigger only upon code change
		* backup/restore terraform state:
			* in main.tf add: terraform { backend "s3" { bucket = "my-bucket" key = "terraform.tfstate" } }
			* as last step in Jenkins bckup the state: "aws s3 cp terraform.tfstate s3://my-bucket"

5. Assumption #2: authentication is not required
	* I assumed there is no need to authenticate the end-user.
	* in real-life scenario i would not expose the lambda and api gateway to public use by implementing the following:
		* add IAM or API Key authorization to my lambda
		* implement private API Gateway in my VPC to prevent access from the internet. based on: https://docs.aws.amazon.com/apigateway/latest/developerguide/apigateway-private-apis.html
		* if a private API is not suitable then i would setup authentication to the API gateway: https://docs.aws.amazon.com/apigateway/latest/developerguide/security-iam.html#security_iam_authentication
	
# Install and config

* create aws user with progrematic-enabled access key and minimum permissions

* install Jenkins 
	* brew install jenkins-lts
	* brew services start jenkins-lts
	* cat /Users/abugov/.jenkins/secrets/initialAdminPassword
	* install suggested plugins
	* create global secret-text for aws progrematic access: aws-secret-key-id, aws-secret-access-key
	* create pipeline from https://github.com/abugov/bankleumi-test