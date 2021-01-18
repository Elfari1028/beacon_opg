FROM google/dart


WORKDIR /app/

COPY pubspec.* /app/
RUN export PUB_HOSTED_URL="https://mirrors.tuna.tsinghua.edu.cn/dart-pub"


COPY . /app/
RUN pub get --offline