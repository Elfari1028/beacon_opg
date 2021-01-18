FROM google/dart


WORKDIR /app/

COPY pubspec.* /app/


COPY . /app/
RUN pub get --offline