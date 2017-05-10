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
LoadPlugin snmp
LoadPlugin tcpconns
LoadPlugin unixsock
LoadPlugin uptime

<Plugin snmp>
  <Data "ssg5_cpu_1min">
    Type "percent"
    Table false
    Instance "netscreen_cpu_1min"
    Values ".1.3.6.1.4.1.3224.16.1.2.0"
  </Data>
  <Data "ssg5_cpu_5min">
    Type "percent"
    Table false
    Instance "netscreen_cpu_5min"
    Values ".1.3.6.1.4.1.3224.16.1.3.0"
  </Data>
  <Data "ssg5_allocated_sessions">
    Type "current_sessions"
    Table false
    Instance "netscreen_allocated_sessions"
    Values ".1.3.6.1.4.1.3224.16.3.2.0"
  </Data>
  <Data "ssg5_mem_free">
    Type "memory"
    Table false
    Instance "netscreen_mem_free"
    Values ".1.3.6.1.4.1.3224.16.2.2.0"
  </Data>
  <Data "std_traffic">
    Type "if_octets"
    Table true
    Instance "IF-MIB::ifName"
    Values "IF-MIB::ifHCInOctets" "IF-MIB::ifHCOutOctets"
  </Data>
  <Host "ssg5">
    Interval 30
    Address "172.16.2.1"
    Version 2
    Community "myPassword"
    Collect "std_traffic" "ssg5_cpu_1min" "ssg5_cpu_5min" "ssg5_allocated_sessions" "ssg5_mem_free"
  </Host>
</Plugin>

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
