#!/bin/bash

cd ~

if [ "$(which ss-server)" = "" ] ; then
	apt -y install shadowsocks-libev
fi

if [ ! -f /usr/local/bin/v2ray-plugin ] ; then
	if [ ! -f v2ray-plugin_linux_amd64 ] ; then
		if [ ! -f v2ray-plugin-linux-amd64-v1.3.1.tar.gz ] ; then
				wget https://github.com/shadowsocks/v2ray-plugin/releases/download/v1.3.1/v2ray-plugin-linux-amd64-v1.3.1.tar.gz
		fi
		tar xvf v2ray-plugin-linux-amd64-v1.3.1.tar.gz
	fi
	mv v2ray-plugin_linux_amd64 /usr/local/bin/v2ray-plugin
fi

if [ "$(cat /etc/shadowsocks-libev/config.json | grep v2ray-plugin)" = "" ] ; then
	cat > /etc/shadowsocks-libev/config.json << CONFIG_EOF
{
    "server":"0.0.0.0",
    "server_port":12345,
    "local_port":1080,
    "password":"epwqgdnvrh",
    "timeout":300,
    "method":"xchacha20-ietf-poly1305",
    "plugin":"v2ray-plugin",
    "plugin_opts":"server"
}
CONFIG_EOF
fi

if [ "$(ps aux | grep ss-server | grep config.json)" = "" ] ; then
	/etc/init.d/shadowsocks-libev start
fi

/etc/init.d/shadowsocks-libev status

echo "maybe you shuld restart : /etc/init.d/shadowsocks-libev restart"
