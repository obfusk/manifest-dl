[]: {{{1

    File        : README.md
    Maintainer  : Felix C. Stegerman <flx@obfusk.net>
    Date        : 2014-10-16

    Copyright   : Copyright (C) 2014  Felix C. Stegerman
    Version     : v0.1.0

[]: }}}1

[![Gem Version](https://badge.fury.io/rb/manifest-dl.png)](https://rubygems.org/gems/manifest-dl)

## Description
[]: {{{1

  manifest-dl - download extra files for your ruby app

  Sometimes you have a (web) app that needs some extra files (e.g.
  terms and conditions) that you don't want to have to upload
  manually, but prefer (e.g. because they're not very small) not to
  have in your version control system.

  manifest-dl allows you to specify the paths, urls and checksums in a
  manifest and automatically downloads those extra files for you (and
  updates them when they -- i.e. their checksums -- change).

  NB: uses `curl` to download files; you'll need to have it installed.

[]: }}}1

## Examples
[]: {{{1

### Rails

```
# Gemfile
gem 'manifest-dl', require: 'manifest-dl/rails'
```

```yaml
# config/manifest-dl.yaml
- path:       public/uploads/t-and-c.pdf
  url:        https://example.com/path/to/tandc.pdf
  sha512sum:  9c573b5ed223f076b4f0c9483608c2d341eb8...
```

```
# .gitignore
/.manifest-dl-cache
```

```bash
rake manifest:dl    # run!
```

### Standalone

```ruby
require 'manifest-rb'
ManifestRB.run!
```

[]: }}}1

## Specs & Docs

```bash
rake spec   # TODO
rake docs
```

## TODO

  * gpg support?
  * what to do with errors?
  * specs/docs?
  * ...

## License

  LGPLv3+ [1].

## References

  [1] GNU Lesser General Public License, version 3
  --- http://www.gnu.org/licenses/lgpl-3.0.html

[]: ! ( vim: set tw=70 sw=2 sts=2 et fdm=marker : )
