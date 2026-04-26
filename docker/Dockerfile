# Dockerfile for LilyPond development on Ubuntu 24.04 LTS
# Based on the official LilyPond docker/base/Dockerfile.ubuntu-22.04
# Updated for Ubuntu 24.04 LTS with all necessary build dependencies

FROM ubuntu:24.04
ARG DEBIAN_FRONTEND=noninteractive
ARG TZ=Etc/UTC

# Install system dependencies
RUN apt-get update && apt-get --no-install-recommends install -y \
    # Build tools
    autoconf \
    automake \
    bison \
    build-essential \
    clang \
    flex \
    g++ \
    make \
    pkgconf \
    python3 \
    python3-pip \
    python3-dev \
    git \
    rsync \
    wget \
    curl \
    \
    # Font and text rendering libraries
    fontconfig \
    libfontconfig1-dev \
    libfreetype6-dev \
    libpango1.0-dev \
    libpangocairo-1.0-0 \
    libpangoft2-1.0-0 \
    libharfbuzz-dev \
    libcairo2-dev \
    libglib2.0-dev \
    \
    # Graphics and image processing
    libpng-dev \
    libjpeg-dev \
    libtiff-dev \
    zlib1g-dev \
    imagemagick \
    \
    # GhostScript for PDF processing
    ghostscript \
    libgs-dev \
    \
    # Font utilities
    fontforge \
    python3-fontforge \
    t1utils \
    \
    # TeX Live for documentation
    texinfo \
    texlive-binaries \
    texlive-fonts-recommended \
    texlive-font-utils \
    texlive-lang-cyrillic \
    texlive-metapost \
    texlive-plain-generic \
    texlive-latex-base \
    texlive-latex-recommended \
    texlive-latex-extra \
    texlive-extra-utils \
    \
    # Fonts
    fonts-dejavu-core \
    fonts-texgyre \
    fonts-urw-base35 \
    fonts-liberation \
    fonts-noto \
    fonts-noto-cjk \
    fonts-noto-color-emoji \
    lmodern \
    \
    # Guile (Scheme interpreter)
    guile-3.0-dev \
    guile-3.0 \
    \
    # Internationalization
    gettext \
    libgettextpo-dev \
    \
    # Development utilities
    libfl-dev \
    libtool \
    \
    # Documentation tools
    help2man \
    \
    # Certificate handling
    ca-certificates \
    \
    # Clean up
    && rm -rf /var/lib/apt/lists/* \
    && find /usr/lib -name "*.a" ! -name "libc_nonshared.a" ! -name "libdl.a" ! -name "libgcc.a" ! -name "libpthread.a" -delete \
    && rm -rf /usr/share/doc /usr/share/info /usr/share/man \
    && rm -rf /usr/share/icons /usr/share/mime /usr/share/zoneinfo

# Configure git for safe directory usage
RUN git config --system --add safe.directory '*'

# Create a non-root user for development
RUN useradd -m -s /bin/bash dev \
    && apt-get update \
    && apt-get install --no-install-recommends -y sudo \
    && echo dev ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/dev \
    && chmod 0440 /etc/sudoers.d/dev \
    && rm -rf /var/lib/apt/lists/*

# Set environment variables for LilyPond executable
# This will only work after LilyPond is built and installed in
# /home/dev/lilypond/install for the first time
ENV PATH="/home/dev/lilypond/install/bin:${PATH}"

# Set up the development environment
USER dev
WORKDIR /home/dev

# Add useful aliases and environment variables
RUN echo 'export PS1="\[\033[01;32m\]lilypond-dev@\h:\w\$\[\033[00m\] "' >> ~/.bashrc \
    && echo 'alias ll="ls -laF"' >> ~/.bashrc \
    && echo 'export LANG=en_US.UTF-8' >> ~/.bashrc \
    && echo 'export LC_ALL=en_US.UTF-8' >> ~/.bashrc

# Set default command
CMD ["/bin/bash"]

# Labels for metadata
LABEL maintainer="coffee | metal | code" \
      description="Ubuntu 24.04 LTS container with LilyPond build dependencies" \
      version="24.04"
