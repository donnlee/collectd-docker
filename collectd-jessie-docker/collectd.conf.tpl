Hostname "{{ HOST_NAME | default(HOSTNAME) }}"
FQDNLookup false

BaseDir "/var/lib/collectd"
PluginDir "/usr/lib/collectd"
TypesDB "/usr/share/collectd/types.db"

Interval 10
Timeout 2
ReadThreads 10
WriteThreads 10
# Avoid memory issue if one of the write plugins is slow (e.g. graphite)
WriteQueueLimitHigh 250000
WriteQueueLimitLow 250000

LoadPlugin contextswitch
LoadPlugin cpu
LoadPlugin df
LoadPlugin interface
LoadPlugin load
LoadPlugin memory
LoadPlugin tcpconns
LoadPlugin unixsock
LoadPlugin uptime

<Plugin df>
        FSType "rootfs"
        FSType sysfs
        FSType proc
        FSType devtmpfs
        FSType devpts
        FSType tmpfs
        FSType fusectl
        FSType cgroup
        IgnoreSelected true
        ValuesAbsolute true
        ValuesPercentage false
</Plugin>

<Plugin cpu>
  ReportByCpu false
  ReportByState true
  ValuesPercentage true
</Plugin>

<Plugin interface>
        Interface "eth0"
        IgnoreSelected false
</Plugin>

<Plugin unixsock>
        SocketFile "/var/run/collectd-unixsock"
        SocketGroup "collectd"
        SocketPerms "0666"
        DeleteSocket true
</Plugin>

<Include "/etc/collectd/collectd.conf.d">
    Filter "*.conf"
</Include>
