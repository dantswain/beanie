# Beanie

Beanie is a Docker registry web viewer powered by Elixir & Phoenix

The goal of Beanie is to allow a team to communicate effectively about
the contents of their private Docker registry.  A Docker registry does
not provide a particularly easy way to list images and their tags;
Beanie uses the registry's REST API to extract this information and
display it on a web page.

Beanie is still very much WIP and experimental.  Feedback is welcome!

## Setup

### Running locally

The usual Phoenix workflow applies here.  This assumes you have
Elixir, Phoenix, and Postgres installed.  Eventually I will make a
Dockerfile for this and post the image on Dockerhub to make this
easier.

```
mix deps.get
mix compile
mix ecto.create
mix ecto.migrate
mix phoenix.server
```

The included [docker-compose.yml](docker-compose.yml) can launch a
simple registry locally.

```
docker-compose up -d registry
```

Configure the repository via [config/config.exs](config/config.exs).
Currently only basic HTTP auth is supported.

```
config :beanie,
  # ...
  docker_registry: [:at_url, ["https://localhost:5000", "testuser", "testpasswd"]]
```

**NOTE** If you change your registry, you should reset the database by
calling `mix ecto.reset`.

### Running in docker

Pull the images by running `docker-compose pull`.  Then launch the
registry and postgres databases:

```
docker-compose up -d registry
docker-compose up -d postgres
```

Build the node modules and your static assets:

```
docker-compose run --rm node npm install
docker-compose run --rm node ./node_modules/brunch/bin/brunch build
```

Build the application:

```
rm -rf deps _build
docker-compose run --rm mix deps.get
docker-compose run --rm mix compile
docker-compose run --rm mix phoenix.digest
```

Then run it:

```
docker-compose up web
```

### Creating images in the local repository

For development, you can build and push some small images using
[test_image/tiny.Dockerfile](test_image/tiny.Dockerfile).  The image
will contain the file message.txt, so if you want to change the image,
just change the file and rebuild.

```
cd test_image
docker build -t my_image -f tiny.Dockerfile .
docker tag my_image localhost:5000/my_image:first
docker push localhost:500/my_image:first
echo "foo" > message.txt"
docker build -t my_image -f tiny.Dockerfile .
docker tag my_image localhost:5000/my_image:latest
docker push localhost:500/my_image:latest
```
