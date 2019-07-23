# AWS 

This folder contains:
 * Dockerrun.aws.json
 * EB_CLI

 ### Dockerrun.aws.json

 This file needs to be uploaded to Elastic Beanstalk application version imediatly after the yo generator is used to create this microservice

 ### EB_CLI

 Use `aws elasticbeanstalk create-environment` command to create the enviroment for the microservice
 When all development for the microservice is done the enviroment should by green.