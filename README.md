# docker-qcollect
Docker Image for QNIBCollect (fullerite port)

## Hello World

To get started just fire up the compose file. The assumption is, you run a docker-engine (tested w/ 1.12) on `unix:///var/run/docker.sock`.

```
$ docker-compose up -d
Creating consul
Creating influxdb
Creating qcollect
Creating grafana3
$
```

After a couple of seconds all services should be up and one can find influxdb under [localhost:8083](http://localhost:8083).

![](/pics/influxdb.png)

And the preloaded influxdb dashboard under [localhost:3000/dashboard/db/dockerstats-dash](http://localhost:3000/dashboard/db/dockerstats-dash).

![](/pics/grafana3.png)

## Filtering

**Please Note**: The collector filters out containers matching the pattern `[a-z]+_[a-z]+`, which will match all non-named containers.

Meaning: All containers started without `--name`, `container_name` (docker-compose.yml) or as a docker service.

