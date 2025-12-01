# 使用申威基础镜像
FROM registry.uniontech.com/uos-server-base/uos-server-20-1070-sw:sw64

# 设置工作目录
WORKDIR /app

# 复制项目文件
COPY . .

# 设置可执行权限
RUN chmod +x port.sh

# 设置环境变量
ENV PATH="/app:${PATH}"

# 定义入口命令
ENTRYPOINT ["./port.sh"]
