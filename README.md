# toolbox.elixir.pm

A site to list Hex packages by category. Inspired by <http://ruby-toolbox.com>.

## Status

WIP. See [TODOs](#todo).

Feedback super welcome; major code contributions currently not desired:

Since I'm doing this in part to learn Phoenix, I **might not accept pull requests** for things I'd rather implement myself. Once the basic functionality is there, this will change.


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
    ssh dokku run toolbox mix ecto.migrate


## TODO:

### Pre-MVP
- [x] List package names
- [x] Load packages into DB via some endpoint

### MVP
- [ ] Category CRU(D)
- [ ] Assigning (flat) categories to packages
- [ ] Update packages on a schedule

### Nice-to-have
- [ ] Conditional GET
- [ ] List package descriptions
- [ ] Show stats from Hex
- [ ] Show stats from GitHub
- [ ] GitHub auth
- [ ] Set up CI
- [ ] Favicon
- [ ] Exception logging

## License and credits

By Henrik Nyh 2015-11-08 under the MIT license.
