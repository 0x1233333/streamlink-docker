FROM ubuntu:latest

# 更新包管理器并安装系统依赖
RUN apt-get update && apt-get install -y \
    curl \
    jq \
    python3 \
    python3-pip \
    git \
    ffmpeg \
    && apt-get clean

# 设置国内 pip 镜像源（可选）
RUN pip3 config set global.index-url https://mirrors.aliyun.com/pypi/simple/

# 安装 pip 相关工具
RUN pip3 install --upgrade pip setuptools wheel

# 安装 streamlink 和 yt-dlp
RUN pip3 install streamlink yt-dlp

# 复制脚本到容器中
COPY script.sh /usr/local/bin/script.sh

# 确保脚本有执行权限
RUN chmod +x /usr/local/bin/script.sh

# 运行脚本
CMD ["/usr/local/bin/script.sh"]
