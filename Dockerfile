FROM debian:stretch

RUN apt-get update && apt-get install -y --no-install-recommends \
  procps \
  python \
  python-pip \ 
  && apt-get clean 

RUN pip install click

COPY . /cli-example

RUN chmod +x /cli-example/scripts/*
ENV PATH="$PATH:/cli-example/scripts"
