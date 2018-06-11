# PYDIO container

## RUN

`in current directory`

```shell
docker run -d \
  --name pydio \
  --restart=always \
  -p 7777:80 \
  haneu89/pydio
```