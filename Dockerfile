FROM python:3.9-slim

# 安装必要的系统依赖
RUN apt-get update && apt-get install -y \
    curl \
    jq \
    ffmpeg \
    && apt-get clean

# 安装 streamlink 和 yt-dlp
RUN pip3 install streamlink yt-dlp

# 复制脚本到容器中
COPY script.sh /usr/local/bin/script.sh

# 确保脚本有执行权限
RUN chmod +x /usr/local/bin/script.sh

# 确认脚本已复制
RUN ls -l /usr/local/bin/

# 运行脚本
ENTRYPOINT ["/usr/local/bin/script.sh"]
