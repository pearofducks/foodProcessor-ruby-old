FROM       debian:wheezy
MAINTAINER pearofducks <pearofducks@gmail.com>

RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install -y build-essential curl wget git vim
ENV HOME /root
RUN curl -sSL https://gist.githubusercontent.com/pearofducks/676c1d45ad5e18926729/raw/1ce11d241fa10b42c6dc1898bb08869590b4a517/ruby_setup.sh | sh
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ADD . /app
RUN cd /app && bundle install

VOLUME ["/in"]
VOLUME ["/out"]

CMD ["/usr/local/bin/foreman","start","-d","/app"]
