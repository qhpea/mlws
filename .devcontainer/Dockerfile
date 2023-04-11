FROM mcr.microsoft.com/devcontainers/base:ubuntu
RUN sudo apt-get update && sudo apt-get install -y python3-venv
# llvm-9
USER vscode
RUN curl -sSL https://install.python-poetry.org | python3 -
RUN curl micro.mamba.pm/install.sh | bash
USER root
# ENV LLVM_CONFIG=/usr/lib/llvm-9/bin/llvm-config