#!/bin/bash
# 预先构建项目镜像的脚本，加快 docker compose up 的速度


UV_VERSION=0.8.19
MIRRORS_URL=mirrors.ustc.edu.cn
CLEAN_APT_CACHE=0

if [ ! -f ".cache/ros.key" ]; then
    echo "ROS key not found, run 'scripts/download-ros-key.sh' to download it."
    exit 1
fi

# 镜像列表（格式：镜像名:标签）
IMAGES=(
  "ubuntu:24.04"
  "ros:jazzy-perception-noble"
  "ghcr.io/astral-sh/uv:${UV_VERSION}"
)

for IMAGE in "${IMAGES[@]}"; do
  NAME=$(echo "${IMAGE}" | cut -d: -f1)
  TAG=$(echo "${IMAGE}" | cut -d: -f2-)
  if ! docker images | grep -q "^${NAME}[[:space:]]\+${TAG}[[:space:]]"; then
    echo "pull image: ${IMAGE}"
    docker pull "${IMAGE}" || {
      echo "failed to pull image ${IMAGE}, aborting!";
      exit 1;
    }
  else
    echo "found ${IMAGE}, skip docker pull."
  fi
done

docker build -t mobile-robot:latest -f dockerfiles/Dockerfile \
  --build-arg UV_VERSION=${UV_VERSION} \
  --build-arg MIRRORS_URL=${MIRRORS_URL} \
  --build-arg CLEAN_APT_CACHE=${CLEAN_APT_CACHE} \
  --no-cache .
