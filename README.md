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

Populate the database from the Hex API:

    mix run -e 'Toolbox.PackageSync.run'

Now visit <http://localhost:4000>.


Want to wipe the DB and start over?

    mix ecto.reset


## Test

    mix test


## Production

Deployed to Dokku. This deploys and then runs migrations, if any:

    script/deploy


## TODO:

### Pre-MVP
- [x] List package names
- [x] Load packages into DB via some endpoint

### MVP
- [ ] Category CRU(D)
- [ ] Assigning (flat: "Phoenix / Auth") categories to packages
- [ ] Update packages on a schedule

### Pre-launch
- [x] List package descriptions
- [x] Exception logging
- [ ] Verify all packages are synced (e.g. count them)
- [ ] Prettify
- [ ] Look into VPS memory usage

### Nice-to-have
- [ ] Show stats from Hex
- [ ] Show stats from GitHub
- [ ] Sass
- [ ] CI
- [ ] Favicon
- [ ] Conditional GETs for API sync
- [ ] GitHub auth?


## License and credits

By Henrik Nyh 2015-11-08 under the MIT license.
