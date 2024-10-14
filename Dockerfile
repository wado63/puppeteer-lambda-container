ARG FUNCTION_DIR="/function"

FROM node:20.17.0-bookworm-slim AS build-image

# aws-lambda-ricのinstallや実行に必要なパッケージをインストール
# https://github.com/aws/aws-lambda-nodejs-runtime-interface-client/tree/main
RUN apt-get update &&\
    apt-get upgrade -y &&\
    apt-get install -y \
    python3 \
    g++ \
    make \
    cmake \
    unzip \
    libcurl4-openssl-dev \
    autoconf \
    libtool \
    build-essential

ARG FUNCTION_DIR
ENV PUPPETEER_SKIP_DOWNLOAD="true"

WORKDIR ${FUNCTION_DIR}

COPY package.json package-lock.json bundle.mjs ./
COPY src ./src

RUN npm install
RUN npm run build


FROM node:20.17.0-bookworm-slim

# chromeで必要になるパッケージをインストール
# https://source.chromium.org/chromium/chromium/src/+/main:chrome/installer/linux/debian/dist_package_versions.json

RUN apt-get update &&\
    apt-get upgrade -y &&\
    apt-get install -y \
    libasound2 \
    libatk-bridge2.0-0 \
    libatk1.0-0 \
    libatspi2.0-0 \
    libc6 \
    libcairo2 \
    libcups2 \
    libdbus-1-3 \
    libdrm2 \
    libexpat1 \
    libgbm1 \
    libglib2.0-0 \
    libnspr4 \
    libnss3 \
    libpango-1.0-0 \
    libpangocairo-1.0-0 \
    libstdc++6 \
    libudev1 \
    libuuid1 \
    libx11-6 \
    libx11-xcb1 \
    libxcb-dri3-0 \
    libxcb1 \
    libxcomposite1 \
    libxcursor1 \
    libxdamage1 \
    libxext6 \
    libxfixes3 \
    libxi6 \
    libxkbcommon0 \
    libxrandr2 \
    libxrender1 \
    libxshmfence1 \
    libxss1 \
    libxtst6 &&\
    apt-get clean && rm -rf /var/lib/apt/lists/*

ARG FUNCTION_DIR

WORKDIR ${FUNCTION_DIR}

COPY --from=build-image ${FUNCTION_DIR} ${FUNCTION_DIR}

RUN npx @puppeteer/browsers install chrome-headless-shell@129

ENTRYPOINT ["/usr/local/bin/npx", "aws-lambda-ric"]
CMD ["dist/lambdaExample.handler" ]
