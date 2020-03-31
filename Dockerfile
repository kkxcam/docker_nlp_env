FROM nvidia/cuda:9.0-cudnn7-devel-ubuntu16.04
LABEL maintainer "NVIDIA CORPORATION <cudatools@nvidia.com>"

ENV CUDNN_VERSION 7.0.4.31
LABEL com.nvidia.cudnn.version="${CUDNN_VERSION}"

# 基础安装
RUN apt-get update && apt-get install -y --no-install-recommends \
        build-essential \
        apt-utils curl g++ \
        cmake \
        git \
        wget \
        tzdata \
        vim \
        ubuntu-make \
        openssl \        
        libssl-dev \
        libreadline-dev \
        gcc \
        binutils \
        patch \
        bzip2 \
        flex \
        bison \
        make \
        autoconf \
        libopencv-dev \
        libsnappy-dev \
        libbz2-dev \
        libc6-dev \
        libffi-dev \
        libgdbm-dev \
        liblzma-dev \
        libncurses5-dev \
        libncursesw5-dev \
        libreadline6-dev \
        libreadline-dev \
        libsqlite3-dev \
        sqlite3 \
        tcl-dev \
        tk-dev \
        uuid-dev \
        zlib1g-dev

RUN rm -rf /var/lib/apt/lists/*

# # 安装 cudnn 7.4.2.24
# RUN apt-get update && apt-get install -y --no-install-recommends \
#             libcudnn7=$CUDNN_VERSION-1+cuda9.0 \
#             libcudnn7-dev=$CUDNN_VERSION-1+cuda9.0 && \
#     apt-mark hold libcudnn7 && \
# #     rm -rf /var/lib/apt/lists/*
# WORKDIR /usr/local
# COPY libcudnn7-dev_7.4.2.24-1+cuda10.0_amd64.deb /usr/local
# RUN dpkg -i libcudnn7-dev_7.4.2.24-1+cuda10.0_amd64.deb 


# 安装 jdk1.8
WORKDIR /usr
RUN mkdir /usr/local/java
ADD jdk-8u241-linux-x64.tar.gz /usr/local/java/
ENV JAVA_HOME=/usr/local/java/jdk1.8.0_241
ENV JRE_HOME $JAVA_HOME/jre
ENV CLASSPATH $JAVA_HOME/bin/dt.jar:$JAVA_HOME/lib/tools.jar:$JRE_HOME/lib:$CLASSPATH
ENV PATH $JAVA_HOME/bin:$PATH

# 显示中文编码问题
# RUN locale-gen zh_CN.UTF-8
# export LANG="C.UTF-8"
ENV LANG zh_CN.UTF-8    
ENV LANGUAGE zh_CN



# # 升级openssl 
# ADD openssl-1.1.1-pre8.tar.gz /usr/local
# WORKDIR /usr/local/openssl-1.1.1-pre8
# RUN ./config --prefix=/usr/local/openssl no-zlib && make && make install 
# RUN rm -rf /usr/include/openssl && ln -s /usr/local/openssl/include/openssl /usr/include/openssl
# RUN rm -rf /usr/bin/openssl && ln -s /usr/local/openssl/bin/openssl /usr/bin/openssl
# RUN ln -s /usr/local/openssl/lib/libssl.so.1.1 /usr/lib/libssl.so.1.1
# RUN ln -s /usr/local/openssl/lib/libcrypto.so.1.1 /usr/lib/libcrypto.so.1.1
# RUN echo "/usr/local/openssl/lib" > /etc/ld.so.conf && ldconfig -v
# ENV PATH /usr/local/openssl:$PATH
# ENV PATH /usr/local/openssl/bin:$PATH

# # 使用 libressl 代替系统的openssl   libressl获取地址：ftp.openbsd.org/pub/OpenBSD/LibreSSL/ 
# ADD libressl-2.8.0.tar.gz /usr/local
# WORKDIR /usr/local/libressl-2.8.0
# RUN ./config --prefix=/usr/local/ssl no-zlib && make && make install
# RUN rm -rf /usr/bin/openssl && ln -s /usr/local/ssl/bin/openssl /usr/bin/openssl
# RUN rm -rf /usr/include/openssl && ln -s /usr/local/ssl/include/openssl /usr/include/openssl
# RUN echo "/usr/local/ssl/lib" > /etc/ld.so.conf.d/libressl-2.8.0.conf 
# RUN ldconfig
# ENV PATH /usr/local/ssl/bin/openssl:$PATH
# ENV PATH /usr/local/ssl/bin/openssl/bin:$PATH
# ENV PATH /usr/local/ssl/include/openssl:$PATH

RUN echo "set encoding=utf-8\nset fileencoding=utf-8" > ~/.vimrc

# 安装python3.7
ADD Python-3.6.7.tgz  /usr/local
WORKDIR /usr/local/Python-3.6.7
RUN ./configure --prefix=/usr/local/python --with-ssl
RUN make && make install
ENV python=/usr/local/python
ENV PATH $python/bin:$PATH
RUN rm -rf /usr/bin/python && ln -fs /usr/local/python/bin/python3.6 /usr/bin/python
RUN rm -rf /usr/bin/pip && ln -s /usr/local/python/bin/pip3 /usr/bin/pip
COPY requirements.txt /usr/local/
RUN pip --default-timeout=2000 --no-cache-dir install -r /usr/local/requirements.txt -i https://pypi.tuna.tsinghua.edu.cn/simple
# 删除安装包
WORKDIR /usr
RUN rm -rf /usr/local/Python-3.6.7
