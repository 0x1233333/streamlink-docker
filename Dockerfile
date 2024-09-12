FROM python:3.9-slim

# 安装必要的依赖
RUN apt-get update && apt-get install -y \
    curl \
    jq \
    && rm -rf /var/lib/apt/lists/*

# 安装 streamlink 和 yt-dlp
RUN pip install --no-cache-dir streamlink yt-dlp

# 设置工作目录
WORKDIR /app

# 复制脚本到容器中
COPY script.sh /app/

# 设置执行权限
RUN chmod +x /app/script.sh

# 设置环境变量
ENV PATH=$PATH:/root/.local/bin

# 运行脚本
CMD ["/bin/bash", "/app/script.sh"]
