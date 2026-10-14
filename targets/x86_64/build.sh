#!/bin/sh
set -e

# 确保当前脚本在自己的目录下运行
cd "$(dirname "$0")"

echo "当前工作目录: $(pwd)"

# 1. 执行官方编译命令
make image \
  PACKAGES="$(tr '\n' ' ' < packages.list)" \
  FILES=files

echo "=== 编译完成，开始寻找并打包 rootfs ==="

# 2. 自动搜寻 ImageBuilder 生成的 root-x86 目录
ROOTFS_DIR=$(find . -maxdepth 3 -type d -name "root-x86" | head -n 1)

if [ -n "$ROOTFS_DIR" ] && [ -d "$ROOTFS_DIR" ]; then
  echo "找到 rootfs 目录: $ROOTFS_DIR，开始打包..."
  cd "$ROOTFS_DIR"
  # 打包并存放到上一层目录（即 targets/x86_64/下）
  tar -czf ../rootfs-x86_64.tar.gz .
  cd ..
  echo "成功生成压缩包：targets/x86_64/rootfs-x86_64.tar.gz"
else
  echo "错误：未找到 root-x86_64 目录！"
  ls -la
  exit 1
fi
