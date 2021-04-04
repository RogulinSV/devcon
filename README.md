# Build Container

```sh
$> docker build --tag frontend:1.0 -f .\Dockerfile .
$> docker build --tag backend:1.0 -f .\Dockerfile .

$> docker buildx create --use --name larger_log --driver-opt env.BUILDKIT_STEP_LOG_MAX_SIZE=50000000
$> docker buildx build --tag backend:1.0 --progress plain -f .\Dockerfile .
```

# Start Container

```sh
$> docker run --rm -it -p 8080:80 -p 8443:443 -v ${pwd}/www:/var/www -v${pwd}/log/nginx:/var/log/nginx --name frontend frontend:1.0
$> docker run --rm -it -p 8025:8025 -p 9003:9003 -v ${pwd}/www:/var/www -v${pwd}/cache/mailhog:/var/mailhog -v${pwd}/log/php:/var/log/php -v${pwd}/log/node:/var/log/node --name backend backend:1.0
```

# Dockerfile Hints
```sh
$> apt-get -o Acquire::Max-FutureTime=145400 update
```

# Useful links
 * [PHP Extensions compatibility list](https://blog.remirepo.net/post/2020/09/21/PHP-extensions-status-with-upcoming-PHP-8.0)
 * [Xdebug Settings](https://xdebug.org/docs/all_settings)
 * [Xdebug with PHPStorm](https://www.jetbrains.com/help/phpstorm/configuring-xdebug.html)
 * [TypeScript Book](https://basarat.gitbook.io/typescript/)