FROM ubuntu:latest

# 安装必需的软件
RUN apt-get update && apt-get install -y \
    curl \
    jq \
    yt-dlp \
    streamlink \
    python3 \
    python3-pip \
    && apt-get clean

# 安装 Streamlink 和 yt-dlp
RUN pip3 install streamlink yt-dlp

# 复制脚本到容器中
COPY script.sh /usr/local/bin/script.sh

# 确保脚本有执行权限
RUN chmod +x /usr/local/bin/script.sh

# 环境变量
ENV API_KEY=你的APIKEY \
    CHANNEL_ID=你的频道ID \
    COOKIES_FILE=/root/cookies.txt \
    PORT=6000 \
    QUALITY="best" \
    RETRY_OPEN=30 \
    RETRY_MAX=0 \
    SEGMENT_TIMEOUT=600 \
    STREAM_TIMEOUT=900 \
    BUFFER_SIZE="64M" \
    CHECK_INTERVAL=60

# 运行脚本
CMD ["/usr/local/bin/script.sh"]
