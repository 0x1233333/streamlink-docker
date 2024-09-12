#!/bin/bash

# 配置 PATH 环境变量
export PATH=$PATH:/root/.local/bin

# 读取配置文件
source <(grep = config.ini | sed 's/ *= */=/g')

# 配置
API_KEY=${API_KEY:-123456789}
CHANNEL_ID=${CHANNEL_ID:-UCrBrSyQaXOoPLICAzS69O3A}
COOKIES_FILE=${COOKIES_FILE:-"/vol1/1000/streamlink/cookies/cookies.txt"}
PORT=${PORT:-6000}
QUALITY=${QUALITY:-"best"}
RETRY_OPEN=${RETRY_OPEN:-30}
RETRY_MAX=${RETRY_MAX:-0}
SEGMENT_TIMEOUT=${SEGMENT_TIMEOUT:-600}
STREAM_TIMEOUT=${STREAM_TIMEOUT:-900}
BUFFER_SIZE=${BUFFER_SIZE:-"64M"}
CHECK_INTERVAL=${CHECK_INTERVAL:-60}

while true; do
    echo "检查直播流..."
    API_RESPONSE=$(curl -s "https://www.googleapis.com/youtube/v3/search?part=snippet&channelId=$CHANNEL_ID&eventType=live&type=video&key=$API_KEY")
    VIDEO_ID=$(echo "$API_RESPONSE" | jq -r '.items[0].id.videoId')

    if [[ -z $VIDEO_ID || $VIDEO_ID == "null" ]]; then
        echo "未检测到直播流。将在 $CHECK_INTERVAL 秒后再次检查..."
    else
        LIVE_URL="https://www.youtube.com/watch?v=$VIDEO_ID"
        echo "检测到直播流：$LIVE_URL"

        echo "使用 yt-dlp 提取流 URL..."
        STREAM_URL=$(yt-dlp -g --cookies "$COOKIES_FILE" "$LIVE_URL")

        if [[ -z $STREAM_URL ]]; then
            echo "提取流 URL 失败。将在 $CHECK_INTERVAL 秒后重试..."
        else
            echo "启动 streamlink..."
            streamlink "$STREAM_URL" "$QUALITY" \
                --player-external-http \
                --player-external-http-port $PORT \
                --retry-open $RETRY_OPEN \
                --retry-max $RETRY_MAX \
                --stream-segment-timeout $SEGMENT_TIMEOUT \
                --stream-timeout $STREAM_TIMEOUT \
                --ringbuffer-size $BUFFER_SIZE
        fi

        echo "Streamlink 已停止。将在 $CHECK_INTERVAL 秒后重新开始检查..."
    fi

    sleep $CHECK_INTERVAL
done
