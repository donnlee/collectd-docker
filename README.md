# collectd-docker
Generic collectd 5.5 docker image. Sends stats to your influxdb specified by 'docker run' env vars.

# Example usage

Pulling from Docker Hub:

$ docker run -dit --name mycollectd  -e HOST_NAME=collectd-host -e INFLUXDB_PORT_25826_UDP_ADDR=influxdb.monitoring.default.example.com -e INFLUXDB_PORT_25826_
UDP_PORT=25826 donn/collectd-docker

See also:

https://github.com/donnlee/influxdb-docker
