# --                                                            ; {{{1
#
# File        : manifest-dl/rake.rb
# Maintainer  : Felix C. Stegerman <flx@obfusk.net>
# Date        : 2014-10-20
#
# Copyright   : Copyright (C) 2014  Felix C. Stegerman
# Licence     : LGPLv3+
#
# --                                                            ; }}}1

require 'rake/dsl_definition'

require 'manifest-dl'

# namespace
module ManifestDL

  # rake tasks
  module Rake
    extend ::Rake::DSL

    # define rake task manifest:dl
    def self.define_tasks
      desc 'download extra files w/ manifest-dl'
      task 'manifest:dl' do
        ManifestDL.run!
      end
    end

  end

end

# vim: set tw=70 sw=2 sts=2 et fdm=marker :
