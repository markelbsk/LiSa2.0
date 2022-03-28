FROM alpine:3.14

RUN apk update 
RUN apk add --no-cache iptables tcpdump

ADD ./docker/proxy/run.sh $HOME/run.sh

RUN chmod +x run.sh
CMD ["./run.sh"]
