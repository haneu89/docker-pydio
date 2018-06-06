# PYDIO container

## RUN

```shell
docker run -d \
  --name pydio \
  --restart=always \
  -v $(pwd):/var/www/pydio/data/personal
  -p 7777:80
  haneu89/pydio
```