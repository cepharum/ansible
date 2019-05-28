FROM alpine:latest

COPY docker /

RUN apk add --update py2-pip git openssh-client nano libffi-dev python2-dev openssl-dev build-base && \
	pip install ansible && \
	apk del libffi-dev python2-dev openssl-dev build-base && \
	rm -rf /var/cache/apk/* && \
	ln -s /etc/ansible/.ssh /root/.ssh && \
	chmod +x /ctl.sh

VOLUME /etc/ansible

ENTRYPOINT ["/ctl.sh"]
