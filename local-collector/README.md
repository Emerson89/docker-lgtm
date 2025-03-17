## Dependencies

- go
- docker

-- install go linux

```bash
wget https://go.dev/dl/go1.23.6.linux-amd64.tar.gz
rm -rf /usr/local/go && tar -C /usr/local -xzf go1.23.6.linux-amd64.tar.gz
export PATH=$PATH:/usr/local/go/bin
```

-- Instalar o telemetrygen

https://github.com/open-telemetry/opentelemetry-collector-contrib/blob/main/cmd/telemetrygen/README.md


```bash
go install github.com/open-telemetry/opentelemetry-collector-contrib/cmd/telemetrygen@latest
sudo cp bin/telemetrygen /usr/local/bin/
```

Execute o docker-compose ou docker


```bash
docker-compose up
```

ou

```bash
docker run -p 4317:4317 -p 8888:8888 -v $(pwd)/config.yaml:/etc/otelcol-contrib/config.yaml ghcr.io/open-telemetry/opentelemetry-collector-releases/opentelemetry-collector-contrib:0.86.0
```

No config.yaml podemos realizar as mudanças necessárias no caso estou tentando o sampling

```yaml
 tail_sampling:
    decision_wait: 5s
    num_traces: 100
    expected_new_traces_per_sec: 10
    policies:
      [
          {
            name: only-10-percent,
            type: probabilistic,
            probabilistic: {sampling_percentage: 10}
          },
      ]    
```      

No browser abra a url http://localhost:8888/metrics é com ela que olhamos as metricas do collector e identificamos o sampling

- Mão na Massa

Em um segundo terminal execute o telemetrygen para gerar traces, iremos fazer o type "always_sample"

## always_sample

```json
          {
            name: test-policy-1,
            type: always_sample
          },
```          

```bash
telemetrygen traces --otlp-insecure --traces 1000
```

Podemos ver que temos 2000 spans, ou seja dois spans por traces

```json
otelcol_receiver_accepted_spans{receiver="otlp",service_instance_id="03ecf55e-19ad-4004-abcd-0d857ed084fe",service_name="otelcol-contrib",service_version="0.86.0",transport="grpc"} 2000
```
e o nosso exporter recebeu 100% dos spans

```json
otelcol_exporter_sent_spans{exporter="debug",service_instance_id="03ecf55e-19ad-4004-abcd-0d857ed084fe",service_name="otelcol-contrib",service_version="0.86.0"} 2000
```

## Com sampling 10% probabilistic

Vou enviar os mesmos 1000 traces

```bash
telemetrygen traces --otlp-insecure --traces 1000
```

Recebemos os mesmos 2000 spans no receiver

```json
otelcol_receiver_accepted_spans{receiver="otlp",service_instance_id="cf93f9a5-d7c5-4e7d-8f97-ba0ce30103c6",service_name="otelcol-contrib",service_version="0.86.0",transport="grpc"} 2000
```

porém no meu exporter irá cerca de 10% spans

```json
otelcol_exporter_sent_spans{exporter="debug",service_instance_id="cf93f9a5-d7c5-4e7d-8f97-ba0ce30103c6",service_name="otelcol-contrib",service_version="0.86.0"} 198
```

Outras duas metricas que podemos visualizar

**Rastros não amostrados**

```json
otelcol_processor_probabilistic_sampler_count_traces_sampled{policy="only-10-percent",sampled="false",service_instance_id="cf93f9a5-d7c5-4e7d-8f97-ba0ce30103c6",service_name="otelcol-contrib",service_version="0.86.0"} 901
```

**Rastros amostrados**

```json
otelcol_processor_probabilistic_sampler_count_traces_sampled{policy="only-10-percent",sampled="true",service_instance_id="cf93f9a5-d7c5-4e7d-8f97-ba0ce30103c6",service_name="otelcol-contrib",service_version="0.86.0"} 99
```

**Metricas**

```bash
otelcol_processor_tail_sampling_count_traces_sampled
```
```bash
otelcol_receiver_accepted_spans
```
```bash
otelcol_exporter_sent_spans
```

https://github.com/open-telemetry/opentelemetry-collector-contrib/blob/main/processor/tailsamplingprocessor/README.md