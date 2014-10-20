# --                                                            ; {{{1
#
# File        : manifest-dl.rb
# Maintainer  : Felix C. Stegerman <flx@obfusk.net>
# Date        : 2014-10-20
#
# Copyright   : Copyright (C) 2014  Felix C. Stegerman
# Licence     : LGPLv3+
#
# --                                                            ; }}}1

require 'digest/sha1'
require 'fileutils'
require 'pathname'
require 'tmpdir'
require 'yaml'

# namespace
module ManifestDL

  class InvalidItemError  < StandardError; end
  class SystemError       < StandardError; end
  class VerificationError < StandardError; end

  DEFAULT_CONFIG  = './config/manifest-dl.yaml'
  DEFAULT_CACHE   = './.manifest-dl-cache'

  # --

  # download files in manifest
  def self.run!(opts = {})
    quiet       = opts.fetch(:quiet)        { false           }
    config_file = opts.fetch(:config_file)  { DEFAULT_CONFIG  }
    cache_dir   = opts.fetch(:cache_dir)    { DEFAULT_CACHE   }
    YAML.load(File.read(config_file)).map do |item|
      _check! item
      _dl?(item, cache_dir) ? _dl!(item, quiet, cache_dir) : nil;
    end .compact
  end

  # --

  # check item
  def self._check!(item)
    raise InvalidItemError,
      "unexpected/missing keys for item #{item.inspect}" \
        unless item.keys.sort == %w{ path sha512sum url }
    raise InvalidItemError,
      "non-string keys for item #{item.inspect}" \
        unless item.keys.all? { |x| String === x }
  end

  # download, verify, mv file
  def self._dl!(item, quiet, cache_dir)
    $stderr.puts "==> #{item['path']}" unless quiet
    Dir.mktmpdir do |dir|
      tempfile = Pathname.new(dir).join('dl').to_s
      _curl! item['url'], tempfile, quiet
      _verify! tempfile, item['sha512sum']
      FileUtils.mkdir_p File.dirname(item['path'])
      FileUtils.mv tempfile, item['path'], force: true
      _cache! item['path'], item['sha512sum'], cache_dir
    end
    item['path']
  end

  # should file be downloaded?
  # (i.e. does not exist or sum has changed)
  def self._dl?(item, cache_dir)
    return true unless File.exist? item['path']
    _cached_sha512sum(item['path'], cache_dir) != item['sha512sum']
  end

  # --

  # download file w/ curl
  def self._curl!(url, file, quiet)
    args = %w{ curl -L } + (quiet ? %w{ -s } : []) + ['-o', file, '--', url]
    # no shell b/c multiple args!
    system(*args) or raise SystemError 'curl returned non-zero'
    nil
  end

  # verify file
  def self._verify!(file, sum)
    # no shell b/c multiple args!
    sum2 = IO.popen(%w{ shasum -a 512 } + [file]) { |f| f.gets.split.first }
    raise SystemError 'shasum returned non-zero' unless $?.success?
    raise VerificationError, file unless sum == sum2
    nil
  end

  # get item's cached sha512sum;
  # returns nil if cache file does not exist
  def self._cached_sha512sum(path, cache_dir)
    file = _cachefile cache_dir, path
    File.exist?(file) ? File.read(file) : nil
  end

  # cache item's sha512sum (based on sha1sum of path)
  def self._cache!(path, sum, cache_dir)
    FileUtils.mkdir_p cache_dir
    File.write _cachefile(cache_dir, path), sum
    nil
  end

  # cache file path
  def self._cachefile(cache_dir, path)
    sha1 = Digest::SHA1.hexdigest path
    Pathname.new(cache_dir).join(sha1).to_s
  end

end

# vim: set tw=70 sw=2 sts=2 et fdm=marker :
