# toolbox.elixir.pm

WIP: A site to list Hex packages by category. Inspired by <http://ruby-toolbox.com>.


## Development

You are expected to have Elixir and Postgres installed.

    mix deps.get
    mix ecto.setup
    mix phoenix.server

Now visit <http://localhost:4000>.

Want to wipe the DB and start over?

    mix ecto.reset



## Test

    mix test


## Production

Deployed to Dokku.

    git push dokku


## TODO:

### Pre-MVP
- Load packages into DB via some endpoint
- List package names

### MVP
- Category CRU(D)
- Assigning (flat) categories to packages
- Update packages on a schedule

### Nice-to-have
- List package descriptions
- Show stats from Hex
- Show stats from GitHub
- GitHub auth
- Set up CI
- Favicon

## License and credits

By Henrik Nyh 2015-11-08 under the MIT license.
