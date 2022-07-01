# docker-vrprouting

![Docker automated](https://img.shields.io/docker/cloud/automated/pgrouting/vrprouting)
![Docker status](https://img.shields.io/docker/cloud/build/pgrouting/vrprouting)
![Docker builds](https://img.shields.io/docker/pulls/pgrouting/vrprouting)


vrpRouting Docker images.

## Contents
- [Contents](#contents)
- [Versions](#versions)
- [Tag roles](#tag-roles)
- [How to use](#how-to-use)
- [How to build images](#how-to-build-images)
- [Develop](#develop)
- [License](#license)
- [Links](#links)

## Versions

There are following versions available:

- With vrpRouting v0:
  - [0.3.0 with Postgres 13 + PostGIS 3.1 + pgRouting 3.2.0](13-3.1-3.2.0-0.3.0/). Docker image: `pgrouting/vrprouting:13-3.1-3.2.0-0.3.0`
  - [0.3.0 with Postgres 12 + PostGIS 3.1 + pgRouting 3.2.0](12-3.1-3.2.0-0.3.0/). Docker image: `pgrouting/vrprouting:12-3.1-3.2.0-0.3.0`
  - [0.3.0 with Postgres 11 + PostGIS 3.1 + pgRouting 3.2.0](11-3.1-3.2.0-0.3.0/). Docker image: `pgrouting/vrprouting:11-3.1-3.2.0-0.3.0`
- With vrpRouting main branch (*):
  - [main branch with Postgres 13 + PostGIS 3.1 + pgRouting 3.2.0](13-3.1-3.2.0-main/). Docker image: `pgrouting/vrprouting:13-3.1-3.2.0-main`
  - [main branch with Postgres 12 + PostGIS 3.1 + pgRouting 3.2.0](12-3.1-3.2.0-main/). Docker image: `pgrouting/vrprouting:12-3.1-3.2.0-main`
  - [main branch with Postgres 11 + PostGIS 3.1 + pgRouting 3.2.0](11-3.1-3.2.0-main/). Docker image: `pgrouting/vrprouting:11-3.1-3.2.0-main`
- With vrpRouting develop branch (*):
  - [develop branch with Postgres 13 + PostGIS 3.1 + pgRouting 3.2.0](13-3.1-3.2.0-develop/). Docker image: `pgrouting/vrprouting:13-3.1-3.2.0-develop`
  - [develop branch with Postgres 12 + PostGIS 3.1 + pgRouting 3.2.0](12-3.1-3.2.0-develop/). Docker image: `pgrouting/vrprouting:12-3.1-3.2.0-develop`
  - [develop branch with Postgres 11 + PostGIS 3.1 + pgRouting 3.2.0](11-3.1-3.2.0-develop/). Docker image: `pgrouting/vrprouting:11-3.1-3.2.0-develop`

(*) If you want to use the last versions of develop or main branches you should consider to build the image by your own. See [here](#how-to-build-images) how to build images:

## Tag roles

`{PostgreSQL major}-{PostGIS major}-{pgRouting version}-{vrpRouting version}`

Tag for vrpRouting 0.3.0 with PostgreSQL 13, PostGIS 3.1, and pgRouting 0.3.0:

`pgrouting/vrprouting:13-3.1-3.2.0-0.3.0`

## How to use

### Running vrpRouting with Docker compose

Run postgres database:
```
$ cd 13-3.1-3.2.0-0.3.0
$ docker-compose up
```

### Running vrpRouting without Docker compose

Run postgres database:
```
$ docker run --name vrprouting -p 5432:5432 pgrouting/vrprouting:13-3.1-3.2.0-0.3.0
```

## How to build images

Building images:
```
$ docker build -t pgrouting/vrprouting:13-3.1-3.2.0-0.3.0 .
```


### Using psql with Docker compose (FIXME):

Example:

```
$ docker-compose exec vrprouting psql -h localhost -U postgres
psql (13.5 (Debian 13.5-1.pgdg110+1))
Type "help" for help.

postgres=# CREATE DATABASE test;
CREATE DATABASE
postgres=# \c test
You are now connected to database "test" as user "postgres".
test=# CREATE EXTENSION postgis;
CREATE EXTENSION
test=# CREATE EXTENSION pgrouting;
CREATE EXTENSION
test=# CREATE EXTENSION vrprouting;
CREATE EXTENSION
test=# SELECT version();
                                                           version
-----------------------------------------------------------------------------------------------------------------------------
 PostgreSQL 13.5 (Debian 13.5-1.pgdg110+1) on x86_64-pc-linux-gnu, compiled by gcc (Debian 10.2.1-6) 10.2.1 20210110, 64-bit
(1 row)

test=# select postgis_full_version();
                                                                       postgis_full_version
-------------------------------------------------------------------------------------------------------------------------------------------------------------------
 POSTGIS="3.1.4 ded6c34" [EXTENSION] PGSQL="130" GEOS="3.9.0-CAPI-1.16.2" PROJ="7.2.1" LIBXML="2.9.10" LIBJSON="0.15" LIBPROTOBUF="1.3.3" WAGYU="0.5.0 (Internal)"
(1 row)

test=# SELECT pgr_version();
 pgr_version
-------------
 3.2.0
(1 row)

test=# SELECT pgr_full_version();
                                                            pgr_full_version
-----------------------------------------------------------------------------------------------------------------------------------------
 (3.2.0,Release,2022/06/30,pgrouting-3.2.0,Linux-5.4.0-80-generic,"PostgreSQL 13.5 (Debian 13.5-1.pgdg110+1)",GNU-10.2.1,1.74.0,unknown)
(1 row)

test=# SELECT vrp_version();
 vrp_version
-------------
 0.3.0
(1 row)

test=# SELECT vrp_full_version();
                                         vrp_full_version
---------------------------------------------------------------------------------------------------
 (0.3.0,Release,2022/07/01,vrprouting-0.3.0,Linux-5.4.0-80-generic,14.4,GNU-10.2.1,1.74.0,unknown)
(1 row)

```

## Develop

To make new version for example `x.x.x`, run following:

```
mkdir 13-3.1-3.2.0-x.x.x
touch 13-3.1-3.2.0-x.x.x/Dockerfile
make update
```

`make update` run `update.sh`, that finds new Dockerfile and generates Dockerfile, docker-compose.yml, README.md, and extra/Dockerfile from template.

## License

This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 2 of the License, or (at your option) any later version.

## Links

- vrpRouting Docker hub: https://hub.docker.com/r/pgrouting/vrprouting/
- pgRouting Docker hub: https://hub.docker.com/u/pgrouting/
- pgRouting project: https://pgrouting.org/
- pgRouting github: https://github.com/pgRouting
