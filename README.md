# puppeteer-lambda-container
PuppeteerをAWS Lambda上でコンテナを使って動かすサンプルです。
ARM64環墫を前提としています。

## ローカルでの実行

```bash
$ npm install
$ npm run build
$ node dist/example.js
```

## ローカルdockerでの実行(puppeteerのみの実行)
Rosettaを使用してx86_64環境で実行します。

```bash
$ arch -x86_64 /bin/zsh
$ docker build --platform=linux/x86_64 -t puppeteer-lambda-container:test .
$ docker run --platform=linux/x86_64 --entrypoint node -it puppeteer-lambda-container:test dist/example.js
```

## lambdaでの実行
ECRにビルドしたイメージをpushして、Lambdaから使用してください。
メモリは1024MB以上を推奨します。


