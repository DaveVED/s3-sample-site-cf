ifndef VERBOSE
MAKEFLAGS += --no-print-directory
endif
SHELL := /bin/bash
.DEFAULT_GOAL := help

STACK_NAME ?= daveved-spa
TEMPLATE_FILE ?= website.yaml
S3_BUCKET_NAME ?= daveved.com
PROFILE ?= dennis-family
REGION ?= us-east-1

help:
	@echo "Available targets:"
	@echo "  help   - Show this help message"
	@echo "  lint   - Validate the CloudFormation template"
	@echo "  build  - Deploy the CloudFormation stack"
	@echo "  clean  - Delete the CloudFormation stack"

lint:
	@echo "Validating CloudFormation template..."
	aws cloudformation validate-template \
		--template-body file://${TEMPLATE_FILE} \
		--profile ${PROFILE} \
		--region ${REGION}

build:
	@echo "Deploying CloudFormation stack..."
	aws cloudformation deploy \
		--stack-name ${STACK_NAME} \
		--template-file ${TEMPLATE_FILE} \
		--parameter-overrides BucketName=${S3_BUCKET_NAME} \
		--profile ${PROFILE} \
		--region ${REGION}

get-s3-website-url:
	@echo "Getting the website URL..."
	$(eval WEBSITE_URL=$(shell aws cloudformation describe-stacks --stack-name ${STACK_NAME} --query "Stacks[0].Outputs[?OutputKey=='WebsiteURL'].OutputValue" --output text --profile ${PROFILE} --region ${REGION}))
	@echo "Website URL: ${WEBSITE_URL}"

deploy: get-s3-website-url
	@echo "Uploading files to the S3 bucket..."
	aws s3 cp src/index.html s3://${S3_BUCKET_NAME}/index.html --profile ${PROFILE} --region ${REGION}
	aws s3 cp src/error.html s3://${S3_BUCKET_NAME}/error.html --profile ${PROFILE} --region ${REGION}

destroy:
	@echo "Deleting CloudFormation stack..."
	aws cloudformation delete-stack \
		--stack-name ${STACK_NAME} \
		--profile ${PROFILE} \
		--region ${REGION}