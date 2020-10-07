import * as pulumi from "@pulumi/pulumi";
import * as aws from "@pulumi/aws";
import * as awsx from "@pulumi/awsx";

// Create an AWS resource (IAM)
const mypolicy = new aws.iam.Policy("my_policy", {
  name: "my_policy",
  policy: JSON.stringify({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": "sns:*",
        "Effect": "Allow",
        "Resource": "arn:aws:sns:my-region:my-account:my_topic"
      },
      {
        "Action": "sqs:*",
        "Effect": "Allow",
        "Resource": "arn:aws:sqs:my-region:my-account:my_queue"
      },
      {
        "Action": "sqs:*",
        "Effect": "Allow",
        "Resource": "arn:aws:sqs:my-region:my-account:my_queue_dlq"
      }
    ]
  })
});

const myuser = new aws.iam.User("my_user", {
  name: "my_user",
});

const policyAttachment = new aws.iam.PolicyAttachment("my_policy_attachment", {
  name: "my_policy_attachment",
  users: [myuser],
  policyArn: mypolicy.arn
});

// Create an AWS resource (SNS)
const myTopic = new aws.sns.Topic("my_topic", {
  name: "my_topic",
  deliveryPolicy: `{
  "http": {
    "defaultHealthyRetryPolicy": {
      "numRetries": 3,
      "numNoDelayRetries": 0,
      "minDelayTarget": 20,
      "maxDelayTarget": 20,
      "numMinDelayRetries": 0,
      "numMaxDelayRetries": 0,
      "backoffFunction": "linear"
    },
    "disableSubscriptionOverrides": false
  }
}
`,
  kmsMasterKeyId: "alias/aws/sns",
  tags: {
    Environment: "myproduction",
  },
});

// Create an AWS resource (SQS)
const myQueueDlq = new aws.sqs.Queue("my_queue_dlq", {
  name: "my_queue_dlq",
  delaySeconds: 90,
  maxMessageSize: 2048,
  messageRetentionSeconds: 86400,
  receiveWaitTimeSeconds: 10,
  policy: JSON.stringify({
    "Version": "2012-10-17",
    "Id": "arn:aws:sqs:my-region:my-account:my_queue_dlq/SQSDefaultPolicy",
    "Statement": [
      {
        "Sid": "__owner_statement",
        "Action": "sqs:*",
        "Effect": "Allow",
        "Resource": "arn:aws:sqs:my-region:my-account:my_queue_dlq",
        "Principal": {
          "AWS": [
            "arn:aws:iam::my-account:user/my_user"
          ]
        }
      }
    ]
  }),
  tags: {
    Environment: "myproduction",
  },
}, { dependsOn: [myuser, mypolicy, policyAttachment] });

const myQueue = new aws.sqs.Queue("my_queue", {
  name: "my_queue",
  delaySeconds: 90,
  maxMessageSize: 2048,
  messageRetentionSeconds: 86400,
  receiveWaitTimeSeconds: 10,
  policy: JSON.stringify({
    "Version": "2012-10-17",
    "Id": "arn:aws:sqs:my-region:my-account:my_queue/SQSDefaultPolicy",
    "Statement": [
      {
        "Sid": "__owner_statement",
        "Action": "sqs:*",
        "Effect": "Allow",
        "Resource": "arn:aws:sqs:my-region:my-account:my_queue",
        "Principal": {
          "AWS": [
            "arn:aws:iam::my-account:user/my_user"
          ]
        }
      }
    ]
  }),
  //redrivePolicy: "{\"deadLetterTargetArn\":\"arn:aws:sqs:my-region:my-account:my_queue_dlq\",\"maxReceiveCount\":\"4\"}",
  tags: {
    Environment: "myproduction",
  },
}, { dependsOn: [myuser, mypolicy, policyAttachment, myQueueDlq] });


export const iamUserName = myuser.id;
export const iamAccesskeyID = myAccessKey.id;
export const iamAccesskeySecret = myAccessKey.sesSmtpPasswordV4;
export const arnPolicy = mypolicy.id;
export const arnTopic = myTopic.id;
export const urlQueueDlq = myQueueDlq.id;
export const urlQueue = myQueue.id;
