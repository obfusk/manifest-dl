# --                                                            ; {{{1
#
# File        : manifest-dl/rails.rb
# Maintainer  : Felix C. Stegerman <flx@obfusk.net>
# Date        : 2014-10-20
#
# Copyright   : Copyright (C) 2014  Felix C. Stegerman
# Licence     : LGPLv3+
#
# --                                                            ; }}}1

require 'rails'

require 'manifest-dl/rake'

# namespace
module ManifestDL

  # railtie that adds the rake tasks
  class Railtie < Rails::Railtie
    rake_tasks { ManifestDL::Rake.define_tasks }
  end

end

# vim: set tw=70 sw=2 sts=2 et fdm=marker :
