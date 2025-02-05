#!/usr/bin/env bash

wget https://go.dev/dl/go1.23.6.linux-amd64.tar.gz
rm -rf /usr/local/go && tar -C /usr/local -xzf go1.23.6.linux-amd64.tar.gz
export PATH=$PATH:/usr/local/go/bin

go install github.com/open-telemetry/opentelemetry-collector-contrib/cmd/telemetrygen@latest
sudo cp bin/telemetrygen /usr/local/bin/

docker run -p 4317:4317 -p 8888:8888 -v $(pwd)/config.yaml:/etc/otelcol-contrib/config.yaml ghcr.io/open-telemetry/opentelemetry-collector-releases/opentelemetry-collector-contrib:0.86.0
