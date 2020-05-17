
GO_BUILD_ARGS     := GOOS=linux GOARCH=amd64
GO_BUILD_LD_FLAGS := -ldflags="-w -s"
GO_BUILD          := $(GO_BUILD_ARGS) go build $(GO_BUILD_LD_FLAGS)

DOCKER_PROJECT_NAMESPACE := charliekenney23/hello-kube

CMD_DIR    := ./cmd
K8S_DIR    := ./k8s
DEPLOY_DIR := ./deploy

GREETER_MAIN_PKG    := $(CMD_DIR)/greeter
GREETER_ENTRY_POINT := $(GREETER_MAIN_PKG)/main.go
GREETER_BIN         := $(GREETER_MAIN_PKG)/greeter

KUBECONFIG_PATH := $(K8S_DIR)/.config/kubeconfig.yaml
KUBECTL_FLAGS   := --kubeconfig=$(KUBECONFIG_PATH)

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

build: deps fmt test go-build docker-build

docker-push:
	docker image ls | grep charliekenney23/hello-kube | grep latest | awk '{print $$1}' | xargs docker push

k8s-apply:
	kubectl $(KUBECTL_FLAGS) apply -f $(K8S_DIR)
	kubectl $(KUBECTL_FLAGS) get services

deploy-cluster:
	(cd deploy; terraform init && terraform apply)
	kubectl $(KUBECTL_FLAGS) apply -f $(K8S_DIR)
	kubectl $(KUBECTL_FLAGS) get services
