# docker-lgtm

- Dependencies

- Docker

```bash
curl -fsSL https://get.docker.com -o get-docker.sh && sudo bash get-docker.sh
```

- Docker compose
```bash
curl -SL https://github.com/docker/compose/releases/download/v2.32.1/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
```
```bash
chmod +x /usr/local/bin/docker-compose 
```

- Uso

```bash
docker-compose up -d
```