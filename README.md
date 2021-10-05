# SQLITE-WEB Docker Image
This project builds a multi-arch Docker image for `sqlite-web`, a SQLite Web Client which is written and maintainer by `Coleifer`:
https://github.com/coleifer/sqlite-web

You can use the `Dockerfile` in this project and build the image like this:

`docker build --compress --tag coleifer/sqlite-web .`

To run it, make sure you understand where your xxxxx.db database is located, and then construct a `docker-compose.yml` instance like this:

```
version: '3.8'

services:
  sqlite-web:
    image: kx1t/sqlite-web
    tty: true
    container_name: acarsdb
    restart: always
    ports:
        - 8080:8080
        environment:
        - SQLITE_DATABASE=sqlite.db
        - URL_PREFIX=/acarsdb
        - EXTRA_ARGS=-r
    volumes:
        - /dir/to/database/file:/data
```
Replace here the directory to your database file in the `volumes:` section, and the name of the database file in the `SQLITE_DATABASE` env variable. `URL_PREFIX` determines what the "root" is of your web page, and pass in any extra arguments (like `-r` for read-only) using the `EXTRA_ARGS` parameter.
