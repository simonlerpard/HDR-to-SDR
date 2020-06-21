FROM ubuntu:20.04

COPY app /app
WORKDIR /app

# Installation tools
RUN apt update && apt install wget gnupg2 xz-utils vim nano -y

# Install mkvtoolnix and jq
RUN wget -q -O - https://mkvtoolnix.download/gpg-pub-moritzbunkus.txt | apt-key add -
RUN echo "deb https://mkvtoolnix.download/ubuntu/ focal main" | tee /etc/apt/sources.list.d/mkvtoolnix.list
RUN echo "deb-src https://mkvtoolnix.download/ubuntu/ focal main" | tee -a /etc/apt/sources.list.d/mkvtoolnix.list
RUN apt update && apt install mkvtoolnix jq -y

# Download and install a precompiled static ffmpeg binary
RUN wget https://johnvansickle.com/ffmpeg/releases/ffmpeg-release-amd64-static.tar.xz
RUN tar xf ffmpeg-release-amd64-static.tar.xz
RUN mv /app/ffmpeg-4.3-amd64-static/ffmpeg /usr/local/bin

ENTRYPOINT ["/bin/bash", "run.sh"]
