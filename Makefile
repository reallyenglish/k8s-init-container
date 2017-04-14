all: push

TAG = 0.2.0
REPO = reallyenglish/k8s-init

container:
	docker build -t $(REPO):$(TAG) .

push: container
	gcloud docker -- push $(REPO):$(TAG)

clean:
	docker rmi $(REPO):$(TAG)
