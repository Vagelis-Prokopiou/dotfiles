#!/usr/bin/env bash

# Author: Vagelis Prokopiou <vagelis.prokopiou@gmail.com>

if [ ! "$1" ]; then
    echo "Usage: $0 <app_name>";
    echo "Example: $0 myapp";
    exit 1;
fi

user="va";
www="/home/${user}/www";
app_name="$1";
distribution=$(lsb_release -a 2> /dev/null | grep --color=auto Description | sed 's/^Description:\s\+//');

echo "[Unit]
Description=.NET Core App running on ${distribution}

[Service]
WorkingDirectory=${www}/${app_name}/public_html
ExecStart=/usr/bin/dotnet ${www}/${app_name}/public_html/${app_name}.dll
Restart=always
# Restart service after 10 seconds if the dotnet service crashes:
RestartSec=10
KillSignal=SIGINT
SyslogIdentifier=dotnet-${app_name}-app
User=${user}
Environment=ASPNETCORE_ENVIRONMENT=Production 

[Install]
WantedBy=multi-user.target" | sudo tee "/etc/systemd/system/kestrel-${app_name}.service";