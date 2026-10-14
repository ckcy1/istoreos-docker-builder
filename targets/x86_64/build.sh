#!/bin/sh

# Build iStoreOS rootfs using ImageBuilder
# Target: x86_64

# 1. 运行官方 ImageBuilder 生成镜像
make image \
  PACKAGES="$(tr '\n' ' ' < packages.list)" \
  FILES=files

# 2. 查找 ImageBuilder 解压出来的根文件系统目录 (通常名为 root-x86_64)
ROOTFS_DIR=$(find . -maxdepth 3 -type d -name "root-x86_64" | head -n 1)

if [ -n "$ROOTFS_DIR" ] && [ -d "$ROOTFS_DIR" ]; then
  echo "Found rootfs directory at: $ROOTFS_DIR"
  echo "Packaging rootfs into rootfs.tar.gz..."
  
  # 3. 将该目录打包为 Docker 所需的 tar.gz 压缩包，并存放在当前目录下
  cd "$ROOTFS_DIR"
  tar -czf ../rootfs.tar.gz .
  cd ..
  
  echo "Successfully generated rootfs.tar.gz!"
else
  echo "Error: Could not find root-x86_64 directory!"
  exit 1
fi
