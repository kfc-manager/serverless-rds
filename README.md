# Serverless RDS

This AWS infrastructure configured with Terraform is an alternative to Amazon's serverless database solution Aurora. The idea originated when I was working with a colleague on a project where we were running a lot of scripts to set up and gather a dataset. We got ourselves a RDS instance, in the process of building the dataset we were running a script about once a week and the rest of the time the RDS instance was not used or accessed in any way. With very little usage of the actual compute resource we were still paying for the whole month. Even though AWS provides a very easy way to shut down the instance through the console, it only gets stopped temporarily for a week. With that on our mind we had to think about when the instance was unused but still active and manually make changes to it's state, which made me want to automize the process and build my own solution as Aurora can also get very pricy if not monitored correctly.

## How it works

![alt text](https://github.com/kfc-manager/serverless-rds/blob/main/assets/serverless-rds.png?raw=true)

## Getting started
