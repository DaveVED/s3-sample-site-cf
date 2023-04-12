# s3-sample-site-cf
CloudFormation template to deploy a static s3 site, using a custom domain.

## Prerequisites
- [x] AWS Account.
- [x] IAM profile on local machine.

## Resources
The template will give you the following resources.
- [x] s3 bucket with source code refernce to local `src` code.

## Usage

To deploy, you can use the `Makefile` attached, following these steps.

#### Step 1 - Update the Makefile

Open up the `Makefile` at the root of your working directory, and update the following variables with your values.

```
STACK_NAME ?= :you-cloudformation-stack-name
TEMPLATE_FILE ?= webstie.yaml
S3_BUCKET_NAME ?= :your-desired-s3-bucket-name
PROFILE ?= :aws-profile
REGION ?= us-east-1
```

You can see the values I used [here](xxx)

***Note -*** If you don't have or know how to setup a AWS profile, you can see that below.

#### Step 2 - Lint your code
Before deploying you can `lint` your code, to ensure it's a valid CloudFormation template.
```
% make lint
Validating CloudFormation template...
aws cloudformation validate-template \
		--template-body file://website.yaml \
		--profile dennis-family \
		--region us-east-1
{
    "Parameters": [
        {
            "ParameterKey": "BucketName",
            "NoEcho": false,
            "Description": "Name of the S3 bucket to be created"
        }
    ],
    "Description": "AWS CloudFormation template to create an S3 bucket and configure it as a static website"
}
```

#### Step 3 - Deploy your Stack
You can now deploy your stack.
```
% make build
Deploying CloudFormation stack...
aws cloudformation deploy \
		--stack-name daveved-s3-site-example \
		--template-file website.yaml \
		--parameter-overrides BucketName=daveved-s3-example \
		--profile dennis-family \
		--region us-east-1

Waiting for changeset to be created..
Waiting for stack create/update to complete
Successfully created/updated stack - daveved-s3-site-example
```

#### Step 4 - Deploy your Code
You can now deploy your code to the s3.
```
% make deploy
Getting the website URL...
Website URL: http://daveved-s3-example.s3-website-us-east-1.amazonaws.com
Uploading files to the S3 bucket...
aws s3 cp src/index.html s3://daveved-s3-example/index.html --profile dennis-family --region us-east-1
upload: src/index.html to s3://daveved-s3-example/index.html      
aws s3 cp src/error.html s3://daveved-s3-example/error.html --profile dennis-family --region us-east-1
upload: src/error.html to s3://daveved-s3-example/error.html  
```

#### Step 5 - Validate Your Deployment
Get your website url, and check it out in your web browser.
```
% make get-s3-website-url
Getting the website URL...
Website URL: http://daveved-s3-example.s3-website-us-east-1.amazonaws.com
```
[SOURCE SITE](/images/website.png)