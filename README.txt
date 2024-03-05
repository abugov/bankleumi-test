 create Jenkins declarative pipeline
	brew install jenkins-lts
	brew services start jenkins-lts
	cat /Users/abugov/.jenkins/secrets/initialAdminPassword
	
manually create REST API Lambda proxy with API gateway
	https://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-create-api-as-simple-proxy-for-lambda.html
	test: https://se9fv7erga.execute-api.us-east-1.amazonaws.com/test/hello?greeter=John

	