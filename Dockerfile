FROM    python:3.6-alpine3.7

LABEL   maintainer="Przemyslaw Ozgo" \
        email="linux@ozgo.info"

ENV     ESHQ_VERSION=3.3.0

RUN \
  apk --no-cache add supervisor py2-pip bash; \
  apk add --no-cache --virtual .build-deps \
        bzip2-dev \
        gcc \
        libc-dev; \
  wget -O /tmp/v${ESHQ_VERSION}.tar.gz https://github.com/ElasticHQ/elasticsearch-HQ/archive/v${ESHQ_VERSION}.tar.gz; \
  mkdir -p /src; \
  tar zxvf /tmp/v${ESHQ_VERSION}.tar.gz -C /src --strip-components=1; \
  rm -f /tmp/v${ESHQ_VERSION}.tar.gz; \
  pip3 install -U -r /src/requirements.txt; \
  pip3 install gunicorn; \
  cp /src/deployment/logging.conf /src/logging.conf; \
  cp /src/deployment/gunicorn.conf /src/gunicorn.conf; \
  mkdir -p /var/log/supervisor; \
  apk del .build-deps; \
  rm -rf /var/cache/apk/* 

EXPOSE 5000

CMD ["supervisord", "-c", "/src/deployment/supervisord.conf"]