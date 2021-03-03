#!/bin/bash
set -e

exec java -Xms4G -Xmx16G -jar /app/src/paper.jar --nogui -W /app/data/worlds --plugins /app/src/plugins $@
