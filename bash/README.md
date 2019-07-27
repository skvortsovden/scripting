
### http_counter.sh
The script was created for using as input for monitoring telegraf(as collector) + influxdb(as storage) + Grafana(as view).

```
Telegraf Configuration:

[[inputs.exec]]
  commands = ["sh /path/http_counter.sh"]
  timeout = "5s"
  data_format = "influx"
```
