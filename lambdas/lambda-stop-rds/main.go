package main

import (
	"context"
	"errors"
	"os"

	"github.com/aws/aws-lambda-go/lambda"
	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/service/cloudwatch"
	"github.com/aws/aws-sdk-go/service/rds"
)

func rdsTrafficAlarm(awsSession *session.Session) (bool, error) {
	serviceClient := cloudwatch.New(awsSession)
	alarmID := os.Getenv("METRIC_ALARM_ID")

	alarmInput := &cloudwatch.DescribeAlarmsInput{
		AlarmNamePrefix: aws.String(alarmID),
	}
	result, err := serviceClient.DescribeAlarms(alarmInput)
	if err != nil {
		return false, err
	}
	if len(result.MetricAlarms) == 0 {
		return false, errors.New("Could not access metric alarm state")
	}
	state := result.MetricAlarms[0].StateValue
	if *state == "ALARM" {
		return true, nil
	}

	return false, nil
}

func stopInstance(awsSession *session.Session) error {
	serviceClient := rds.New(awsSession)
	instanceID := os.Getenv("RDS_ID")

	statusInput := &rds.DescribeDBInstancesInput{
		DBInstanceIdentifier: aws.String(instanceID),
	}
	result, err := serviceClient.DescribeDBInstances(statusInput)
	if err != nil {
		return err
	}
	if len(result.DBInstances) == 0 {
		return errors.New("Could not access DB Instances state")
	}
	status := result.DBInstances[0].DBInstanceStatus
	if *status != "available" {
		return nil
	}

	stopInput := &rds.StopDBInstanceInput{
		DBInstanceIdentifier: aws.String(instanceID),
	}
	_, err = serviceClient.StopDBInstance(stopInput)
	if err != nil {
		return err
	}

	return nil
}

func handler(
	ctx context.Context,
) error {
	awsSession, err := session.NewSession(&aws.Config{
		Region: aws.String(os.Getenv("REGION")),
	})
	if err != nil {
		return err
	}

	// check if RDS traffic is in "ALARM" state
	stop, err := rdsTrafficAlarm(awsSession)
	if err != nil {
		return err
	}

	// stop instance if state is in "ALARM"
	if stop {
		return stopInstance(awsSession)
	}

	return nil
}

func main() {
	lambda.Start(handler)
}
