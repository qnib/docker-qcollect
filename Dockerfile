# QNIBTerminal image
FROM qnib/alpn-consul

ENV FULLERITE_GRAPHITE_INTERVAL=4 \
    FULLERITE_INTERVAL=4 \
    FULLERITE_PREFIX=qcollect \
    FULLERITE_GRAPHITE_ENABLED=false \
    FULLERITE_GRAPHITE_INTERVAL=4 \
    FULLERITE_GRAPHITE_PREFIX_DIMENSIONS=false \
    FULLERITE_GRAPHITE_SERVER=carbon.service.consul \
    FULLERITE_INFLUXDB_ENABLED=false \
    FULLERITE_INFLUXDB_SERVER=influxdb.service.consul \
    FULLERITE_INFLUXDB_PORT=8086 \
    FULLERITE_INFLUXDB_INTERVAL=4 \
    FULLERITE_INFLUXDB_USERNAME=root \
    FULLERITE_INFLUXDB_PASSWORD=root \
    FULLERITE_INFLUXDB_DATABASE=fullerite

RUN echo "2016-06-19.1" \
 && apk add --update nmap bc jq openssl \
 && wget -qO /usr/local/bin/go-github https://github.com/qnib/go-github/releases/download/0.2.2/go-github_0.2.2_Linux \
 && chmod +x /usr/local/bin/go-github \
 && mkdir -p /opt/fullerite/bin \
 && wget -qO /opt/fullerite/bin/fullerite $(/usr/local/bin/go-github rLatestUrl --ghorg qnib --ghrepo QNIBCollect --limit 1 --regex "fullerite.*-NoZMQ-LinuxMusl$") \
 && chmod +x /opt/fullerite/bin/fullerite \
 && rm -rf /var/cache/apk/* /usr/local/bin/go-github
ADD etc/consul-templates/fullerite/fullerite.conf.ctmpl /etc/consul-templates/fullerite/
ADD etc/fullerite/conf.d/ /etc/fullerite/conf.d/
ADD etc/consul.d/fullerite.json /etc/consul.d/
ADD opt/qnib/fullerite/bin/check.sh \
    opt/qnib/fullerite/bin/start.sh \
    opt/qnib/fullerite/bin/warn.sh \
    /opt/qnib/fullerite/bin/
ADD etc/supervisord.d/fullerite.ini /etc/supervisord.d/
RUN echo 'tail -f /var/log/supervisor/fullerite.log' >> /root/.bash_history
