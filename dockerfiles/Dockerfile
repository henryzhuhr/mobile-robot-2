ARG UV_VERSION=0.8.19
FROM ghcr.io/astral-sh/uv:${UV_VERSION} AS uv-builder

# https://hub.docker.com/_/ros
# https://github.com/osrf/docker_images/blob/master/ros/jazzy/ubuntu/noble/perception/Dockerfile
FROM ros:jazzy-perception-noble

# ============================================================
# 「必须」软件列表 MUST_INSTALL_LIST
# ============================================================
ARG MUST_INSTALL_LIST=""
ARG MUST_INSTALL_LIST="$MUST_INSTALL_LIST ca-certificates locales"
ARG MUST_INSTALL_LIST="$MUST_INSTALL_LIST zsh"
ARG MUST_INSTALL_LIST="$MUST_INSTALL_LIST git"
ARG MUST_INSTALL_LIST="$MUST_INSTALL_LIST python3-dev"

# ============================================================
# 「可选」软件列表 OPTION_INSTALL_LIST
# ============================================================
ARG OPTION_INSTALL_LIST=""
# ARG OPTION_INSTALL_LIST="$OPTION_INSTALL_LIST ubuntu-server"
ARG OPTION_INSTALL_LIST="$OPTION_INSTALL_LIST vim nano tree pciutils iputils-ping dnsutils"
ARG OPTION_INSTALL_LIST="$OPTION_INSTALL_LIST openssh-client"
ARG OPTION_INSTALL_LIST="$OPTION_INSTALL_LIST build-essential"
ARG OPTION_INSTALL_LIST="$OPTION_INSTALL_LIST cmake ninja-build clang clangd"
# ARG OPTION_INSTALL_LIST="$OPTION_INSTALL_LIST ros-jazzy-perception=0.11.0-1*"
ARG OPTION_INSTALL_LIST="$OPTION_INSTALL_LIST ros-jazzy-desktop-full"
ARG OPTION_INSTALL_LIST="$OPTION_INSTALL_LIST x11-xserver-utils x11-apps net-tools"
# ARG OPTION_INSTALL_LIST="$OPTION_INSTALL_LIST libxcb-keysyms1-dev libxcb-image0-dev \
#     libxcb-shm0-dev libxcb-icccm4-dev libxcb-sync0-dev libxcb-xfixes0-dev \
#     libxcb-shape0-dev libxcb-randr0-dev libxcb-render-util0-dev \
#     libfontconfig1-dev libfreetype6-dev libx11-dev libxext-dev libxfixes-dev \
#     libxi-dev libxrender-dev libxcb1-dev libx11-xcb-dev libxcb-glx0-dev x11vnc \
#     xauth build-essential mesa-common-dev libglu1-mesa-dev libxkbcommon-dev \
#     libxcb-xkb-dev libxslt1-dev libxkbcommon-x11-0"

# 自定义镜像源
ARG USE_MIRROR=0
ARG MIRRORS_URL="mirrors.cloud.tencent.com"

# 是否清理 apt 缓存
ARG CLEAN_APT_CACHE=1
ARG USER_NAME="root"
ARG USER_HOME="/${USER_NAME}"

# 添加 ROS2 的 key
# COPY .cache/ros.key /usr/share/keyrings/ros-archive-keyring.gpg
RUN curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key  -o /usr/share/keyrings/ros-archive-keyring.gpg

# 安装软件
ENV DEBIAN_FRONTEND=noninteractive
ENV LANG=zh_CN.utf8
ENV INSTALL_LIST="$MUST_INSTALL_LIST $OPTION_INSTALL_LIST"
# set -x 选项会使得每个命令在执行前都会被打印出来，报错时会显示是哪个命令出错
RUN set -x && \
    # ========================
    # Step: Install software
    # ========================
    sed -i 's/#force_color_prompt=yes/force_color_prompt=yes/g' ${HOME}/.bashrc && \
    if [ "$USE_MIRROR" = "1" ]; then { sed -i -e "s#//.*archive.ubuntu.com#//${MIRRORS_URL}#g" -e "s#//ports.ubuntu.com#//${MIRRORS_URL}#g" /etc/apt/sources.list.d/ubuntu.sources; } fi && \
    # 移除镜像中自带的 ROS2 源
    if [ -f "/etc/apt/sources.list.d/ros2-latest.list" ]; then { mv /etc/apt/sources.list.d/ros2-latest.list /etc/apt/sources.list.d/ros2-latest.list.bak; } fi && \
    # 添加 ROS2 源
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://${MIRRORS_URL}/ros2/ubuntu $(. /etc/os-release && echo $UBUNTU_CODENAME) main" | tee /etc/apt/sources.list.d/ros2.list > /dev/null && \
    apt-get update && \
    # apt-get upgrade -y && \ # 升级会导致 ros-desktop-full 无法安装
    apt-get install -y --no-install-recommends ${INSTALL_LIST} && \
    apt-get autoremove -y && \
    if [ "$CLEAN_APT_CACHE" = "1" ]; then { apt-get clean all; rm -rf /var/lib/apt/lists/*; } fi && \
    localedef -i zh_CN -c -f UTF-8 -A /usr/share/locale/locale.alias zh_CN.UTF-8 && \
    # 系统时间错误可能导致: `tls: failed to verify certificate: x509: certificate signed by unknown authority`
    # 修改时区 (date -R 检查当前时间)
    if [ "$USE_MIRROR" = "1" ]; then { ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime; } fi && \
    # 启用 bash 补全
    sed -i.bak '/^#if ! shopt -oq posix; then$/,/^#fi$/s/^#//' /etc/bash.bashrc && \
    # ========================
    # Step: Set zsh as the default shell
    # ========================
    chsh -s /usr/bin/zsh && \
    # ====== install oh-my-zsh (official) ======
    # git clone https://github.com/ohmyzsh/ohmyzsh.git --depth 1 /tmp/ohmyzsh && cd /tmp/ohmyzsh/tools && \
    # sh install.sh && rm -rf /tmp/ohmyzsh && \
    # git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions --depth 1 && \
    # echo "ZSH_CUSTOM=${ZSH_CUSTOM:-/root/.oh-my-zsh/custom}" && \
    # ls -al "${ZSH_CUSTOM:-/root/.oh-my-zsh/custom}" && \
    # cd "${ZSH_CUSTOM:-/root/.oh-my-zsh/custom}" && \
    # git clone https://github.com/zsh-users/zsh-autosuggestions && \
    # ====== install oh-my-zsh (mirror) ======
    git clone http://mirrors.tuna.tsinghua.edu.cn/git/ohmyzsh.git --depth 1 && cd ohmyzsh/tools && \
    REMOTE=https://mirrors.tuna.tsinghua.edu.cn/git/ohmyzsh.git sh install.sh && \
    git clone https://gitee.com/henryzhuhr/zsh-autosuggestions.git --depth 1 ${ZSH_CUSTOM:-/root/.oh-my-zsh/custom}/plugins/zsh-autosuggestions && \
    # ==============================
    # set zsh theme and plugins
    echo "ZSH_THEME='candy'" >> ~/.zshrc && \
    echo "plugins=(macos dotenv git cp python bundler rake rbenv ruby zsh-autosuggestions)" >> ~/.zshrc && \
    echo "ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#00BFFF,bg=gray,bold,underline'" >> ~/.zshrc && \
    echo "ZSH_AUTOSUGGEST_STRATEGY=(history completion)" >> ~/.zshrc && \
    echo "source \$ZSH/oh-my-zsh.sh" >> ~/.zshrc && \
    echo "alias ll='ls -alh'" >> ~/.zshrc && \
    echo "alias la='ls -A'" >> ~/.zshrc && \
    echo "alias l='ls -CF'" >> ~/.zshrc && \
    echo "alias h='history'" >> ~/.zshrc && \
    echo "alias mkdir='mkdir -p'" >> ~/.zshrc && \
    echo "alias grep='grep --color=auto'" >> ~/.zshrc && \
    echo "alias egrep='egrep --color=auto'" >> ~/.zshrc && \
    echo "alias fgrep='fgrep --color=auto'" >> ~/.zshrc && \
    # ROS2
    [ -d "/opt/ros/jazzy/" ] && echo "source /opt/ros/jazzy/setup.zsh" >> $USER_HOME/.zshrc && \
    rm -rf /tmp/*

ENV PATH=$PATH:/opt/ros/jazzy/bin

# ENV LANG=zh_CN.utf8
ENV LANG=US_en.utf8
# 系统时间错误可能导致: `tls: failed to verify certificate: x509: certificate signed by unknown authority`
# 修改时区 (date -R 检查当前时间)
# RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

# ============================================================
#   ⬇️ 扩展 Dockerfile
# ============================================================

# ============================================================
#   Python 环境
# ============================================================
# # PEP 668 – Python base environments Python 增强提案 (PEP)：https://realpython.com/python-virtual-environments-a-primer/?ref=yaolong.net
# # https://www.adamsdesk.com/posts/resolve-pip-externally-managed-environment
# # 临时解决方案  --ignoreExternallyManagedEnvironment
# 使用 uv
COPY --from=uv-builder /uv /uvx /bin/

# 默认使用系统 Python 环境
ENV UV_SYSTEM=true

ENV UV_DEFAULT_INDEX="https://mirrors.cloud.tencent.com/pypi/simple/"
ENV UV_PYTHON_PREFERENCE="system"
RUN set -x && \
    rm -rf $(uv cache dir) && \
    rm -rf /tmp/*

# 环境初始化脚本，加快构建镜像的速度
RUN echo ": $(date +%s):0;zsh scripts/init.sh" >> $USER_HOME/.zsh_history

# 提升虚拟环境 python 的优先级
# ENV PATH=${VIRTUAL_ENV}/bin:$PATH
ENV VIRTUAL_ENV_DISABLE_PROMPT=1
