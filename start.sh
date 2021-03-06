#!/bin/sh

set -e

PREV_PID=`cat prometheus.pid`
if kill -0 $PREV_PID 2>/dev/null; then
    echo "Prometheus is already running as $PREV_PID"
    exit 1
fi

STORAGE_DAYS=60

# Prometheus doesn't understand "days" as a unit
STORAGE_HOURS=$(( $STORAGE_DAYS * 24 ))

nohup ../prometheus/prometheus -config.file=prometheus.yaml \
    -storage.local.path=metrics \
    -storage.local.retention=${STORAGE_HOURS}h \
    -web.external-url=http://matrix.org/prometheus/ \
    -alertmanager.url=http://localhost:9093/ \
    &
PID=$!

echo $PID > prometheus.pid
