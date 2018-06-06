# PYDIO container

## RUN

`in current directory`

```shell
echo "deny from all" > .htaccess

docker run -d \
  --name pydio \
  --restart=always \
  -v $(pwd):/var/www/pydio/data/personal \
  -p 7777:80 \
  haneu89/pydio
```