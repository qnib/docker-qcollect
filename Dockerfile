FROM qnib/alpn-consul

ENV QCOLLECT_GRAPHITE_INTERVAL=4 \
    QCOLLECT_INTERVAL=4 \
    QCOLLECT_PREFIX=qcollect \
    QCOLLECT_GRAPHITE_ENABLED=false \
    QCOLLECT_GRAPHITE_INTERVAL=4 \
    QCOLLECT_GRAPHITE_PREFIX_DIMENSIONS=false \
    QCOLLECT_GRAPHITE_SERVER=carbon.service.consul \
    QCOLLECT_INFLUXDB_ENABLED=false \
    QCOLLECT_INFLUXDB_SERVER=influxdb.service.consul \
    QCOLLECT_INFLUXDB_PORT=8086 \
    QCOLLECT_INFLUXDB_INTERVAL=4 \
    QCOLLECT_INFLUXDB_USERNAME=root \
    QCOLLECT_INFLUXDB_PASSWORD=root \
    QCOLLECT_INFLUXDB_DATABASE=qcollect

RUN echo "2016-06-19.1" \
 && apk add --update nmap bc jq openssl \
 && wget -qO /usr/local/bin/go-github https://github.com/qnib/go-github/releases/download/0.2.2/go-github_0.2.2_MuslLinux \
 && chmod +x /usr/local/bin/go-github \
 && echo "# $(/usr/local/bin/go-github rLatestUrl --ghorg qnib --ghrepo qcollect --limit 1 --regex '.*_alpine$')" \
 && wget -qO /usr/bin/qcollect $(/usr/local/bin/go-github rLatestUrl --ghorg qnib --ghrepo qcollect --limit 1 --regex ".*_alpine$") \
 && chmod +x /usr/bin/qcollect \
 && rm -rf /var/cache/apk/* /usr/local/bin/go-github
ADD etc/consul-templates/qcollect/qcollect.conf.ctmpl /etc/consul-templates/qcollect/
ADD etc/qcollect/conf.d/ /etc/qcollect/conf.d/
ADD etc/consul.d/qcollect.json /etc/consul.d/
ADD opt/qnib/qcollect/bin/check.sh \
    opt/qnib/qcollect/bin/start.sh \
    opt/qnib/qcollect/bin/warn.sh \
    /opt/qnib/qcollect/bin/
ADD etc/supervisord.d/qcollect.ini /etc/supervisord.d/
RUN echo 'tail -f /var/log/supervisor/qcollect.log' >> /root/.bash_history
