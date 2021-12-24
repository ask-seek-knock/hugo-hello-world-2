FROM alpine:latest

ADD run.sh /run.sh

RUN chmod 0755 /run.sh

CMD /run.sh
