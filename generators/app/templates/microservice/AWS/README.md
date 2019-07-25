# AWS 

This folder contains:
 * Dockerrun.aws.json
 * devops_script.sh

 ### Dockerrun.aws.json

 This file needs to be uploaded to Elastic Beanstalk application version imediatly after the yo generator is used to create this microservice

 ### devops_script.sh

 This script is designed to aid in common tasks:                                  
  * ElasticBeanstalk Environment -> new environment, list/update environment variables 
  * RDS Database creation --> PostgreSQL                                               
  * CloudWatch log deletion 