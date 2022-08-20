# OpenCV-Docker 采用Docker部署OpenCV开发环境

## 部署方式

1. 安装必要组件

   ```bash
   # For Ubuntu/Debian
   sudo apt install docker unzip wget
   # For Fedora/REHL
   sudo dnf install docker unzip wget
   # For ArchLinux/Manjaro
   sudo pacman -S docker unzip wget
   ```
2. 将本项目克隆至本地

   ```bash
   git clone https://github.com/chenxijun/opencv-docker.git
   ```
3. 执行脚本

   ```bash
   ./build.sh build.cfg
   ```
