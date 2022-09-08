FROM python:alpine3.8

RUN apk add --no-cache wget \
    && wget -O /usr/bin/wait-for https://raw.githubusercontent.com/eficode/wait-for/master/wait-for \
    && chmod +x /usr/bin/wait-for \
    && apk del wget

COPY requirements.txt /tmp

RUN apk update  && apk add gcompat
# apk --no-cache --allow-untrusted -X https://apkproxy.herokuapp.com/sgerrand/alpine-pkg-glibc add glibc 

RUN apk add --no-cache --virtual build-deps gcc python3-dev musl-dev \
    && apk add --no-cache postgresql-dev \
    && apk add --no-cache --update libffi-dev libgcc libstdc++ \
    && pip install -r /tmp/requirements.txt \
    && apk del build-deps

RUN rm -rf /tmp/requirements.txt

WORKDIR /app
ADD ./run.py /app
ADD ./sqli /app/sqli
ADD ./config /app/config
