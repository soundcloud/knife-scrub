# knife scrub

Chef Knife plugin to scrub normal attributes from chef-server.

## Installation

    gem install knife-scrub

## Usage

The only objects `knife-scrub` can scrub so far are `normal` attributes
from previous roles or cookbook versions, as these might conflict with
existing `default` attributes.

```bash
$ knife scrub attributes nagios.services
```

It's possible to restrict the node search to a given pattern with `--query`:

```bash
$ knife scrub attributes -q roles:web nagios.services
```

The usual `--yes` / `-y` flag works as well:

```bash
$ knife scrub attributes -q roles:web -y nagios.services
```

## Authors

SoundCloud Inc., [Tobias Schmidt](mailto:ts@soundcloud.com)
