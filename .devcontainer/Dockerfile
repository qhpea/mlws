FROM mcr.microsoft.com/devcontainers/base:ubuntu
RUN sudo apt-get update && sudo apt-get install -y cmake git libboost-all-dev libsdl2-dev libopenal-dev
# llvm-9
USER vscode
# RUN curl -sSL https://install.python-poetry.org | python3 -
RUN curl micro.mamba.pm/install.sh | bash
ADD environment.yml .
# RUN bash --login -c 'micromamba env create -f environment.yml'
USER root
# ENV LLVM_CONFIG=/usr/lib/llvm-9/bin/llvm-config