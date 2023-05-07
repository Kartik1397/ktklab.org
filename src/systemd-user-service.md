% systemd user service setup

In this post I will share how I setup a basic user level systemd service to test [ktklab.org](ktklab.org)([source](https://github.com/Kartik1397/ktklab.org)) locally.

Create a new service file `http-server.service` in `~/.config/systemd/user` with following content.

```
[Unit]
Description=http-server

[Service]
ExecStart=/usr/local/bin/http-server -p 8080 /home/ktk/ktklab.org/html

[Install]
WantedBy=multi-user.target
```

You can set value of `ExecStart=` option to  whatever executable you want to run as a systemd service. Make sure to use absolute paths.

Run `systemctl --user daemon-reload` to load new configuration file.\
Run `systemctl --user start http-server` to start http-server service.\
Check the health of service by running `systemctl --user status http-server`.

Now, I can make changes in `src/` directory and run `make clean & make all` to generate fresh html files in `html/` directory and I'll be able to see updated site on `http://localhost:8080`.

