require File.expand_path('../lib/manifest-dl/version', __FILE__)

Gem::Specification.new do |s|
  s.name        = 'manifest-dl'
  s.homepage    = 'https://github.com/obfusk/manifest-dl'
  s.summary     = 'downloads extra files for your app'

  s.description = <<-END.gsub(/^ {4}/, '')
    downloads extra files for your app

    ...
  END

  s.version     = ManifestDL::VERSION
  s.date        = ManifestDL::DATE

  s.authors     = [ 'Felix C. Stegerman' ]
  s.email       = %w{ flx@obfusk.net }

  s.licenses    = %w{ LGPLv3+ }

  s.files       = %w{ .yardopts README.md Rakefile } \
                + %w{ manifest-dl.gemspec } \
                + Dir['{lib,spec}/**/*.rb']

  s.add_runtime_dependency 'rake'

  # s.add_development_dependency 'rspec'

  s.required_ruby_version = '>= 1.9.1'
end
