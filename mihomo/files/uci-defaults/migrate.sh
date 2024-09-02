#!/bin/sh

. "$IPKG_INSTROOT/etc/mihomo/scripts/constants.sh"

# since 1.8.0

## add mihomo.mixin.tcp_keep_alive_idle
tcp_keep_alive_idle=$(uci -q get mihomo.mixin.tcp_keep_alive_idle); [ -z "$tcp_keep_alive_idle" ] && uci set mihomo.mixin.tcp_keep_alive_idle=600

## add mihomo.mixin.fake_ip_filter_mode
fake_ip_filter_mode=$(uci -q get mihomo.mixin.fake_ip_filter_mode); [ -z "$fake_ip_filter_mode" ] && uci set mihomo.mixin.fake_ip_filter_mode=blacklist

## add mihomo.mixin.dns_respect_rules
dns_respect_rules=$(uci -q get mihomo.mixin.dns_respect_rules); [ -z "$dns_respect_rules" ] && uci set mihomo.mixin.dns_respect_rules=1

# commit
uci commit mihomo

# exit with 0
exit 0
