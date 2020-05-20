
GO_BUILD_ARGS     := GOOS=linux GOARCH=amd64
GO_BUILD_LD_FLAGS := -ldflags="-w -s"
GO_BUILD          := $(GO_BUILD_ARGS) go build $(GO_BUILD_LD_FLAGS)

DOCKER_PROJECT_NAMESPACE := charliekenney23/hello-kube

CMD_DIR    := ./cmd
HACK_DIR   := ./hack
DEPLOY_DIR := ./deploy

GREETER_MAIN_PKG    := $(CMD_DIR)/greeter
GREETER_ENTRY_POINT := $(GREETER_MAIN_PKG)/main.go
GREETER_BIN         := $(GREETER_MAIN_PKG)/greeter

K8S_APPLY_SCRIPT := $(HACK_DIR)/k8s_apply.sh

build: deps fmt test go-build docker-build

fmt:
	go fmt ./...

unittest:
	go test -v ./...

test: unittest

deps:
	go mod tidy

greeter-build:
	$(GO_BUILD) -o $(GREETER_BIN) $(GREETER_ENTRY_POINT)

go-build: greeter-build

docker-build:
	(cd $(GREETER_MAIN_PKG) && docker build -t $(DOCKER_PROJECT_NAMESPACE)-greeter .)

docker-push:
	docker image ls | grep $(DOCKER_PROJECT_NAMESPACE) | grep latest | awk '{print $$1}' | xargs docker push

k8s-apply:
	bash $(K8S_APPLY_SCRIPT)

deploy-cluster:
	(cd $(DEPLOY_DIR); terraform init && terraform apply)
	bash $(K8S_APPLY_SCRIPT)

destroy-cluster:
	(cd $(DEPLOY_DIR); terraform destroy)
