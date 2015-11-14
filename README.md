# The BEAM Toolbox

<http://toolbox.elixir.pm>

A site to list Hex packages by category.

Inspired by <http://ruby-toolbox.com>. Name borrowed from Josh Adams of [Elixir Sips](http://elixirsips.com/) with his blessing.


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
- [x] Category CRU(D)
- [x] Assigning (flat: "Phoenix / Auth") categories to packages
- [x] Show grouped by category
- [x] Update packages on a schedule

### Pre-launch
- [x] List package descriptions
- [x] Exception logging
- [x] Verify all packages are synced (e.g. count them)
- [ ] ToC
- [ ] Page titles
- [ ] Rename? "Beambox"?
- [ ] Prettify
  - [ ] Make categorize an icon
- [ ] Improve UX
- [ ] Honeypot for categories to avoid spam?

### Nice-to-have
- [ ] More integrated tests. Hound?
- [ ] Show stats from Hex
- [ ] Show stats from GitHub
- [ ] Sass
- [ ] Slim
- [ ] Favicon
- [ ] CI
- [ ] Handle renamed/removed packages


## License and credits

By Henrik Nyh 2015-11-08 under the MIT license.
