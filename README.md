# collectd-docker
Generic collectd 5.6 docker image. Sends stats to your influxdb specified by 'docker run' env vars.

# unixsock plugin

The container activates collectd's unixsock plugin with unix domain socket `/var/run/collectd-unixsock`

If you want the host machine to write to this socket (because you have stats that you want sent to collectd and then to a TSDB like InfluxDB), then `docker run` with `-v /run:/var/run` (in the case of ubuntu).

# Example usage

Pulling from Docker Hub:

$ docker run -dit --name mycollectd -v /run:/var/run -e HOST_NAME=collectd-host -e INFLUXDB_PORT_25826_UDP_ADDR=influxdb.monitoring.default.example.com -e INFLUXDB_PORT_25826_UDP_PORT=25826 donn/collectd-docker

Or use `docker-compose.yml` file.

See also:

https://github.com/donnlee/influxdb-docker
