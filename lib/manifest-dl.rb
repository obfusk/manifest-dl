# --                                                            ; {{{1
#
# File        : manifest-dl.rb
# Maintainer  : Felix C. Stegerman <flx@obfusk.net>
# Date        : 2014-10-16
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

  DEFAULT_CONFIG  = File.expand_path './config/manifest-dl.yaml'
  DEFAULT_CACHE   = File.expand_path './.manifest-dl-cache'

  # --

  # download files in manifest
  def self.run!(config_file = DEFAULT_CONFIG)
    YAML.load(DEFAULT_CONFIG).each do |item|
      _check! x; _dl! x if _dl? x
    end
  end

  # --

  # check item
  def self._check!(item)
    raise InvalidItemError, "unexpected/missing keys for item #{item.inspect}" \
      unless item.keys.sort == %w{ path sha512sum url }
    raise InvalidItemError, "non-string keys for item #{item.inspect}" \
      unless item.keys.all? { |x| String === x }
  end

  # download, verify, mv file
  def self._dl!(item)
    Dir.mktmpdir do |dir|
      tempfile = Pathname.new(dir).join('dl').to_s
      _curl! item['url'], tempfile
      _verify! tempfile, item['sha512sum']
      FileUtils.mv tempfile, item['path'], force: true
      _cache! item['path'], item['sha512sum']
    end
  end

  # should file be downloaded?
  # (i.e. does not exist or sum has changed)
  def self._dl?(item)
    return true unless File.exist? item['path']
    _cached_sha512sum(item['path']) != item['sha512sum']
  end

  # --

  # download file w/ curl
  def self._curl!(url, file)
    # no shell b/c multiple args!
    system('curl', '-o', file, '--', url) \
      or raise SystemError 'curl returned non-zero'
  end

  # verify file
  def self._verify!(file, sum)
    # no shell b/c multiple args!
    sum2 = IO.popen(%w{ shasum -a 512 } + [file]) { |f| f.gets.split.first }
    raise SystemError 'shasum returned non-zero' unless $?.success?
    raise VerificationError, file unless sum == sum2
  end

  # get item's cached sha512sum;
  # returns nil if cache file does not exist
  def self._cached_sha512sum(path)
    file = _cachefile path
    File.exist?(file) ? File.read(file) : nil
  end

  # cache item's sha512sum (based on sha1sum of path)
  def self._cache!(path, sum)
    FileUtils.mkdir_p DEFAULT_CACHE
    File.write _cachefile(path), sum
  end

  # cache file path
  def self._cachefile(path)
    sha1 = Digest::SHA1.hexdigest path
    Pathname.new(DEFAULT_CACHE).join(sha1).to_s
  end

end

# vim: set tw=70 sw=2 sts=2 et fdm=marker :
