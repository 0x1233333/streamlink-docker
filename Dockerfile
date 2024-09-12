FROM ubuntu:latest

# 安装必需的软件
RUN apt-get update && apt-get install -y \
    curl \
    jq \
    python3 \
    python3-pip \
    git \
    && apt-get clean

# 安装 streamlink 和 yt-dlp
RUN pip3 install --upgrade pip
RUN pip3 install streamlink yt-dlp

# 复制脚本到容器中
COPY script.sh /usr/local/bin/script.sh

# 确保脚本有执行权限
RUN chmod +x /usr/local/bin/script.sh

# 运行脚本
CMD ["/usr/local/bin/script.sh"]
