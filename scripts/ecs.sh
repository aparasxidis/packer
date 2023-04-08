#!/usr/bin/env bash

set -e

# Setting network:
sysctl -w net.ipv4.ip_forward=1
/etc/init.d/network restart
#/etc/init.d/docker restart

# Configure the ECS cluster:
echo ECS_AVAILABLE_LOGGING_DRIVERS='["awslogs","json-file"]' >> /etc/ecs/ecs.config
