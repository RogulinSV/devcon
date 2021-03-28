# Build Container

```sh
$> docker build --tag frontend:1.0 -f .\Dockerfile .
$> docker build --tag backend:1.0 -f .\Dockerfile .

$> docker buildx create --use --name larger_log --driver-opt env.BUILDKIT_STEP_LOG_MAX_SIZE=50000000
$> docker buildx build --tag backend:1.0 --progress plain -f .\Dockerfile .
```

# Start Container

```sh
$> docker run --rm -it -p 8080:80 -p 8443:443 -v ${pwd}/www:/var/www --name frontend frontend:1.0
$> docker run --rm -it -v ${pwd}/www:/var/www --name backend backend:1.0
```

# Dockerfile Hints
```sh
$> apt-get -o Acquire::Max-FutureTime=145400 update
```

# Useful links
 * [https://blog.remirepo.net/post/2020/09/21/PHP-extensions-status-with-upcoming-PHP-8.0] "PHP Extensions compatibility list"