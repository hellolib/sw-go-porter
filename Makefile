# SW Go Porter Docker Makefile

# 镜像名称和标签（支持通过make传参覆盖）
IMAGE_NAME ?= hub.deepin.com/public/sw-go-porter
IMAGE_TAG ?= latest
FULL_IMAGE_NAME := $(IMAGE_NAME):$(IMAGE_TAG)

# 默认目标
.DEFAULT_GOAL := help

# 帮助信息
help: ## 显示帮助信息
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-15s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

build: ## 构建并推送Docker镜像到仓库（需先登录Docker仓库）
	@echo "Building Docker image: $(FULL_IMAGE_NAME)"
	@echo "Note: This image must be built on a SW64 (ShenWei) architecture system"
	docker build -t $(FULL_IMAGE_NAME) .
	@echo "Pushing image to registry: $(FULL_IMAGE_NAME)"
	docker push $(FULL_IMAGE_NAME)

build-local: ## 仅构建Docker镜像（不推送到仓库）
	@echo "Building Docker image locally: $(FULL_IMAGE_NAME)"
	@echo "Note: This image must be built on a SW64 (ShenWei) architecture system"
	docker build -t $(FULL_IMAGE_NAME) .

clean: ## 清理Docker镜像
	@echo "Removing Docker image: $(FULL_IMAGE_NAME)"
	docker rmi -f $(FULL_IMAGE_NAME)

.PHONY: help build push clean
