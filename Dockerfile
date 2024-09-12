FROM python:3.9-slim

# 更新包管理器并安装依赖项
RUN apt-get update && apt-get install -y \
    curl \
    jq \
    git \
    && apt-get clean

# 安装 streamlink 和 yt-dlp
RUN pip install --upgrade pip
RUN pip install streamlink yt-dlp

# 复制脚本到容器中
COPY script.sh /usr/local/bin/script.sh

# 确保脚本有执行权限
RUN chmod +x /usr/local/bin/script.sh

# 运行脚本
CMD ["/usr/local/bin/script.sh"]
