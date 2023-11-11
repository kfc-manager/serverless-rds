package main

import (
	"context"
	"errors"
	"os"

	"github.com/aws/aws-lambda-go/lambda"
	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/service/rds"
)

func handler(
	ctx context.Context,
) error {
	awsSesssion := session.Must(session.NewSession(&aws.Config{
		Region: aws.String(os.Getenv("REGION")),
	}))
	serviceClient := rds.New(awsSesssion)
	instanceID := os.Getenv("RDS_IDENTIFIER")

	statusInput := &rds.DescribeDBInstancesInput{
		DBInstanceIdentifier: aws.String(instanceID),
	}
	result, err := serviceClient.DescribeDBInstances(statusInput)
	if err != nil {
		return err
	}
	if len(result.DBInstances) > 0 {
	} else {
		return errors.New("Could not access DB Instances state")
	}
	status := result.DBInstances[0].DBInstanceStatus
	if *status != "stopped" {
		return nil
	}

	startInput := &rds.StartDBInstanceInput{
		DBInstanceIdentifier: aws.String(instanceID),
	}
	_, err = serviceClient.StartDBInstance(startInput)
	if err != nil {
		return err
	}

	return nil
}

func main() {
	lambda.Start(handler)
}
