# SW Go Porter Docker 使用说明

## 简介

本项目提供了 Docker 镜像支持，方便在申威（SW64）架构系统上使用 `sw-go-porter` 工具移植 Golang 代码。

## 准备工作

1. **架构要求**：Docker 镜像必须在 SW64 架构系统上运行
2. **基础镜像**：使用 `registry.uniontech.com/uos-server-base/uos-server-20-1070-sw:sw64`
3. **Docker 环境**：已安装 Docker 引擎

## 使用方法

### 1. 构建并推送 Docker 镜像到仓库

```bash
# 使用默认镜像名称和标签
make build

# 自定义镜像名称和标签
make build IMAGE_NAME=my-registry.com/my-image IMAGE_TAG=v1.0.0
```

### 2. 仅构建 Docker 镜像（不推送到仓库）

```bash
# 使用默认镜像名称和标签
make build-local

# 自定义镜像名称和标签
make build-local IMAGE_NAME=my-local-image IMAGE_TAG=dev
```

### 3. 清理 Docker 镜像

```bash
make clean
```

### 4. 查看帮助信息

```bash
make help
```

## 注意事项

1. **架构兼容性**：该镜像只能在 SW64 架构系统上运行，无法在 x86_64 等其他架构上运行
2. **模块路径**：确保提供的 `MODULE_PATH` 是有效的 Golang 模块路径，包含 `go.mod` 文件
3. **依赖下载**：工具会自动下载依赖到模块的 `vendor` 目录
4. **移植范围**：仅对 README.md 中列出的支持 Package 进行移植

## 示例

### 使用 Docker 镜像移植 Golang 代码

```bash
# 查看帮助信息
docker run hub.deepin.com/public/sw-go-porter:latest -h

# 移植指定的 Golang 模块
docker run -v /path/to/your/go/module:/module hub.deepin.com/public/sw-go-porter:latest your_module_path
```

### 命令行参数说明

```
Usage: ./port.sh <the root of the golang module to port>

Options:
  -v, --version  output version information and exit
  -h, --help     display this help and exit
```

## 自定义镜像名称和标签

所有命令都支持通过以下参数自定义镜像名称和标签：
- `IMAGE_NAME`: 完整的镜像名称（例如：`my-registry.com/my-image`）
- `IMAGE_TAG`: 镜像标签（例如：`v1.0.0`, `latest`, `dev`）

示例：
```bash
# 构建并推送自定义镜像
make build IMAGE_NAME=my-registry.com/sw-go-porter IMAGE_TAG=v2.0.0

# 本地构建自定义镜像
make build-local IMAGE_NAME=sw-go-porter-local IMAGE_TAG=test

# 清理指定镜像
make clean IMAGE_NAME=my-image IMAGE_TAG=dev
```
