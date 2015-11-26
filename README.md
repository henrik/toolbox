# The BEAM Toolbox

[![Build Status](https://secure.travis-ci.org/henrik/toolbox.svg?branch=master
"Build Status")](https://travis-ci.org/henrik/toolbox)

<http://toolbox.elixir.pm>

A site to list Hex packages by category.

Inspired by <http://ruby-toolbox.com>. Name borrowed from Josh Adams of [Elixir Sips](http://elixirsips.com/) with his blessing.


## Development

You are expected to have Elixir, [Phoenix (including Node.js and npm)](http://www.phoenixframework.org/docs/installation) and Postgres installed.

If the default database user and password does not work for you, you can customize it by setting the `POSTGRES_USER` and/or `POSTGRES_PASSWORD` environment variables.

Then:

    mix deps.get
    mix ecto.setup
    npm install

Populate the database from the Hex API:

    mix run -e "Toolbox.PackageSync.run"

And start the web server:

    mix phoenix.server

Now visit <http://localhost:4000>.


Want to wipe the DB and start over?

    mix ecto.reset


## Test

    mix test


## Production

Deployed to Dokku. This deploys and then runs migrations, if any:

    script/deploy

Get a production console:

    ssh dokku run toolbox "iex -S mix"

### How it was set up

* [Notes from running Dokku on Digital Ocean](https://gist.github.com/henrik/26bb73091712aa42abf2)
* [Deploying Phoenix on Dokku](https://gist.github.com/henrik/c70e32544e09c1a79841)


## Inspired by

* [Awesome Elixir](https://github.com/h4cc/awesome-elixir)
* [The Ruby Toolbox](https://www.ruby-toolbox.com/)


## Possible future inspirations

* [Libraries.io](https://libraries.io/)
* [Ember Observer](http://emberobserver.com/)


## License and credits

By Henrik Nyh 2015-11-08 under the MIT license.
