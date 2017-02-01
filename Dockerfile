FROM alpine:3.5

MAINTAINER Evgeniy Kulikov "im@kulikov.im"

ENV USER           www-data
ENV GROUP          www-data
ENV UID            5001
ENV GID            82

RUN set -x \
    && addgroup -Sg ${UID} ${GROUP} 2>/dev/null \
    && adduser -D -S -h /var/www -s /usr/sbin/nologin -H -u ${UID} -G ${GROUP} ${USER} \
    && mkdir /var/www \
    && chown -hR ${USER}:${GROUP} /var/www \
    && chmod -R a+rw /var/www

RUN set -x \
	&& apk add --no-cache \
		lighttpd \
		lighttpd-mod_auth \
		lighttpd-mod_webdav \
	\
	# Clean caches and temp-files:
	&& (rm -rf /var/cache/apk/* 2> /dev/null || echo "OK") \
	&& (rm -rf /tmp/* 2> /dev/null || echo "OK") \
	&& (rm -rf /tmp/.* 2> /dev/null || echo "OK") \
	&& (rm -rf /root/* 2> /dev/null || echo "OK") \
	&& (rm -rf /root/.* 2> /dev/null || echo "OK")

COPY ./conf/lighttpd.main.conf /etc/lighttpd/lighttpd.conf
COPY ./conf/lighttpd.webdav.conf /etc/lighttpd/webdav.conf
COPY ./conf/start.sh /usrl/local/sbin/run-webdav

EXPOSE 80

CMD ["/usrl/local/sbin/run-webdav"]