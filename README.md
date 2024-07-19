# Serverless-web-application
A serverless web application that enables users to request unicorn rides from the Wild Rydes fleet. The project uses Terraform to manage the infrastructure.

## Application architecture
The application architecture uses AWS Lambda, Amazon API Gateway, Amazon DynamoDB, Amazon Cognito, and AWS Amplify Console. Amplify Console provides continuous deployment and hosting of the static web resources including HTML, CSS, JavaScript, and image files which are loaded in the user's browser. JavaScript executed in the browser sends and receives data from a public backend API built using Lambda and API Gateway. Amazon Cognito provides user management and authentication functions to secure the backend API. Finally, DynamoDB provides a persistence layer where data can be stored by the API's Lambda function.

## AWS Amplify
Used AWS Aplify to host the static resources for our web page application with continues deployment(CD - automation) built in. The Amplify Console provides a git-based workflow for continuous deployment and hosting of full-stack web apps.

## AWS Cognito
Created an Amazon Cognito user pool to manage our users' accounts. The static web has a page that enables customers to register as a new user, verify thier email address, and sign into the site.

## Serverless Backend
Created a Lambda function and Amazon DynamoDB to build a backend process for handling requests for the web applicaiton.

## Amazon API Gateway
Exposed the Lambda function we have created as a RESTful API. This API will be accessible on the public internet and will be secured using the Amazon Cognito user pool. This will turn the statically hosted website into a dynamic web application by adding client-side JavaScript that makes AJAX calls to the exposed APIs.