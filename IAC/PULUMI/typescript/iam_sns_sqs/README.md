# Another IaC tool ...

Modern Infrastructure as Code.

Create, deploy, and manage infrastructure on any cloud using familiar programming languages and tool

In this example we will use Pulumi Crosswalk for AWS to easily create a Topic, Queues and a User with access permissions to them. Pulumi Crosswalk for AWS is a collection of libraries that use automatic well-architected best practices to make common infrastructure-as-code tasks in AWS easier and more secure.

[![asciicast](https://asciinema.org/a/qubHolAxGcNEnbqj3GIjVsq6M.svg)](https://asciinema.org/a/qubHolAxGcNEnbqj3GIjVsq6M)

## Install Pulumi on Linux by running the installation script:

```bash
curl -fsSL https://get.pulumi.com | sh
```

## Install Node.js:

```bash
sudo snap install node --classic
```

## Create a "pulumi_my" project:

```bash
mkdir pulumi_my && cd pulumi_my && pulumi new aws-typescript --emoji --generate-only
```

```bash
nano -c index.ts
```

```ts
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
```

## Change "my-region" and "my-account"

### Replace "my-region" with the region of your choice, for example, if you wanted to use "us-east-2" AKA "Ohio" it would look like below:

```bash
sed -i "s/"my-region"/"us-east-2"/g" index.ts
```

### Replace "my-account" with your AWS account ID without the "-", for example if it were "5555-5555-5555" it would look like below:

```bash
sed -i "s/"my-account"/"555555555555"/g" index.ts
```

## Perform an initial deployment, run the following commands:

```bash
npm install
```

```bash
pulumi stack init
```

## Review the "pulumi_my" project

```bash
pulumi preview
```

## Set AWS_PROFILE:

```bash
pulumi config set aws:profile my-profile
```

## Set AWS_REGION:

```bash
pulumi config set aws:region us-east-2
```

## Deploy the Stack

```bash
pulumi up
```

## Destroy the "pulumi_my" project

```bash
pulumi destroy
```

## Remove the "pulumi_my" project from Stack

```bash
pulumi stack rm dev
```

## Source:

<https://www.pulumi.com/docs/get-started/>

<https://www.pulumi.com/docs/guides/crosswalk/aws/>

<https://www.pulumi.com/docs/reference/pkg/>

<https://www.pulumi.com/docs/intro/concepts/state/>
