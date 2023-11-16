# Serverless RDS :magic_wand:

This AWS infrastructure configured with Terraform is an alternative to Amazon's serverless database solution Aurora. The idea originated when I was working with a colleague on a project where we were running a lot of scripts to set up and gather a dataset. We got ourselves a RDS instance, in the process of building the dataset we were running a script about once a week and the rest of the time the RDS instance was not used or accessed in any way. With very little usage of the actual compute resource we were still paying for the whole month. Even though AWS provides a very easy way to shut down the instance through the console, it only gets stopped temporarily for a week. With that on our mind we had to think about when the instance was unused but still active and manually make changes to it's state, which made me want to automize the process and build my own solution as Aurora can also get very pricy if not monitored correctly.

## How it works :thinking:

![alt text](https://github.com/kfc-manager/serverless-rds/blob/main/assets/serverless-rds.png?raw=true)

### &rarr; Network :globe_with_meridians:

- VPC covers two availability zones in set region in order to build a subent group with two private subnets, which fullfills the AWS Multi AZ requirement to create a RDS instance.
- Secutiry groups are set to allow bastion host to communicate with RDS instance over specified database port
- Bastion host can be SSH tunneled into from outside user

### &rarr; Monitor / Logging :mag_right:

- FlowLogs log traffic in network of database and bastion host SSH in two CloudWatch log groups
- Metrics are created to define amount of database traffic and SSH traffic
- Database traffic state goes into "ALARM" when traffic drops below 1 in evaluation time period
- SSH traffic state goes into "ALARM" when traffic is greater than 0 in evaluation time period

### &rarr; Events :boom:

- Scheduled event gets triggered in specified time interval (default 30 min) and invokes stop lambda function
- State change event gets triggered when the SSH traffic state goes into "ALARM" state and invoked start lambda function

### &rarr; Lambdas :wrench:

- Stop function checks the database traffic state and if in "ALARM" state stops the RDS instance
- Start function starts the RDS instance if it is not already in "AVAILABLE" state

## Getting started :rocket:
