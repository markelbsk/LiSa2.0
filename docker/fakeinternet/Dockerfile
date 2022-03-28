FROM ubuntu:18.04

ENV DEBIAN_FRONTEND=noninteractive

# Installation using Tools
RUN apt-get update && apt-get install -y \
    vim \
    wget \
    gnupg \
    iptables \
    net-tools \
    tcpdump \
    sudo

# Installation using apt  
RUN echo "deb http://www.inetsim.org/debian/ binary/" > /etc/apt/sources.list.d/inetsim.list
RUN wget -O ./tmp/key http://www.inetsim.org/inetsim-archive-signing-key.asc
RUN apt-key add ./tmp/key

# update the cache of available packages
RUN apt-get update && apt-get install -y

# install INetSim
RUN apt-get install -y inetsim

ADD ./docker/proxy/run.sh $HOME/run.sh

RUN chmod +x run.sh
CMD ["./run.sh"]
