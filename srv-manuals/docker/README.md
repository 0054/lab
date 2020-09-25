# DOCKER


## вытащить Dockerfile из образа

для этого есть специальный [image](https://hub.docker.com/r/alpine/dfimage)

на примере nginx:latest
```
$ alias dfimage="docker run -v /var/run/docker.sock:/var/run/docker.sock --rm alpine/dfimage"
$ dfimage -sV=1.36 nginx:latest
```
можно без алиаса

