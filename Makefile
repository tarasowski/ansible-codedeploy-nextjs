include .env

package:
	cp codedeploy/appspec.yml .
	cp codedeploy/deploy.sh .
	zip -r deployment.zip . -x "*node_modules*" -x "*.git*" -x "*.next*"
	rm appspec.yml
	rm deploy.sh

upload:
	aws s3 cp deployment.zip s3://$(BUCKET_NAME)/deployment.zip

.PHONY: create_bucket
create_bucket:
	@if [ -z "$$(grep BUCKET_NAME .env)" ]; then \
		export BUCKET_NAME=my-bucket-$$(uuidgen | tr '[:upper:]' '[:lower:]'); \
		aws s3api create-bucket --bucket $$BUCKET_NAME --region $$AWS_REGION; \
		echo "BUCKET_NAME=$$BUCKET_NAME" >> .env; \
	fi