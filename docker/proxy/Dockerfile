FROM alpine:3.14

RUN apk update 
RUN apk add --no-cache iptables 

ADD ./docker/proxy/run.sh $HOME/run.sh

RUN chmod +x run.sh
# RUN ./run.sh
